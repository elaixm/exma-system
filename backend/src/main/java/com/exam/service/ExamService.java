package com.exam.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.exam.common.Constants;
import com.exam.entity.Exam;
import com.exam.entity.ExamLog;
import com.exam.entity.ExamRecord;
import com.exam.mapper.ExamLogMapper;
import com.exam.mapper.ExamMapper;
import com.exam.mapper.ExamRecordMapper;
import com.exam.service.PaperService;
import com.exam.service.ScoreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

@Service
public class ExamService {

    @Autowired
    private ExamMapper examMapper;

    @Autowired
    private ExamRecordMapper examRecordMapper;

    @Autowired
    private ExamLogMapper examLogMapper;

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    @Autowired
    private PaperService paperService;

    @Autowired
    private ScoreService scoreService;

    public void gradeExam(Long examId, Long studentId, String answers) {
        scoreService.gradeExam(examId, studentId, answers);
    }

    public Page<Exam> getExamList(Integer page, Integer size, String status, String keyword) {
        Page<Exam> pageObj = new Page<>(page, size);
        QueryWrapper<Exam> wrapper = new QueryWrapper<>();
        if (status != null && !status.isEmpty()) {
            wrapper.eq("status", status);
        }
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like("title", keyword);
        }
        wrapper.orderByDesc("create_time");
        return examMapper.selectPage(pageObj, wrapper);
    }

    public Exam getExamById(Long id) {
        return examMapper.selectById(id);
    }

    public Exam createExam(Exam exam) {
        // 校验时间设置
        validateExamTime(exam);
        
        exam.setToken(UUID.randomUUID().toString());
        exam.setStatus(Constants.EXAM_STATUS_NOT_STARTED);
        exam.setCreateTime(LocalDateTime.now());
        exam.setUpdateTime(LocalDateTime.now());
        examMapper.insert(exam);
        return exam;
    }

    public void updateExam(Exam exam) {
        // 校验时间设置
        validateExamTime(exam);
        
        exam.setUpdateTime(LocalDateTime.now());
        examMapper.updateById(exam);
    }

    /**
     * 校验考试时间的合法性
     */
    private void validateExamTime(Exam exam) {
        if (exam.getStartTime() == null || exam.getEndTime() == null) {
            throw new RuntimeException("开始时间和结束时间不能为空");
        }
        
        if (exam.getEndTime().isBefore(exam.getStartTime())) {
            throw new RuntimeException("结束时间不能早于开始时间");
        }
        
        if (exam.getStartTime().isEqual(exam.getEndTime())) {
            throw new RuntimeException("开始时间和结束时间不能相同");
        }
        
        // 可选：校验考试时长是否与开始结束时间匹配
        if (exam.getDuration() != null) {
            long minutes = java.time.Duration.between(exam.getStartTime(), exam.getEndTime()).toMinutes();
            if (minutes < exam.getDuration()) {
                throw new RuntimeException("考试时长不能大于开始时间和结束时间的间隔");
            }
        }
    }

    public void deleteExam(Long id) {
        examMapper.deleteById(id);
    }

    public ExamRecord startExam(Long examId, Long studentId, String ipAddress) {
        Exam exam = examMapper.selectById(examId);
        if (exam == null) {
            throw new RuntimeException("考试不存在");
        }

        // 校验考试状态
        if (Constants.EXAM_STATUS_FINISHED.equals(exam.getStatus())) {
            throw new RuntimeException("考试已结束，无法进入");
        }
        if (Constants.EXAM_STATUS_NOT_STARTED.equals(exam.getStatus())) {
            throw new RuntimeException("考试尚未开始，无法进入");
        }

        // 校验考试时间
        LocalDateTime now = LocalDateTime.now();
        if (now.isBefore(exam.getStartTime())) {
            throw new RuntimeException("考试未到开始时间，开始时间为: " + exam.getStartTime());
        }
        if (now.isAfter(exam.getEndTime())) {
            throw new RuntimeException("考试已过结束时间，无法进入");
        }

        QueryWrapper<ExamRecord> wrapper = new QueryWrapper<>();
        wrapper.eq("exam_id", examId);
        wrapper.eq("student_id", studentId);
        ExamRecord existingRecord = examRecordMapper.selectOne(wrapper);

        if (existingRecord != null) {
            if (Constants.EXAM_STATUS_FINISHED.equals(existingRecord.getStatus())) {
                throw new RuntimeException("考试已提交");
            }
            return existingRecord;
        }

        ExamRecord record = new ExamRecord();
        record.setExamId(examId);
        record.setStudentId(studentId);
        record.setStatus(Constants.EXAM_STATUS_IN_PROGRESS);
        record.setIpAddress(ipAddress);
        record.setStartTime(LocalDateTime.now());
        record.setCreateTime(LocalDateTime.now());
        examRecordMapper.insert(record);

        String redisKey = Constants.REDIS_EXAM_PREFIX + examId + ":" + studentId;
        redisTemplate.opsForValue().set(redisKey, record.getId(), exam.getDuration(), TimeUnit.MINUTES);

        logExamAction(examId, studentId, "START_EXAM", "开始考试", ipAddress);

        return record;
    }

    public ExamRecord getExamRecord(Long examId, Long studentId) {
        QueryWrapper<ExamRecord> wrapper = new QueryWrapper<>();
        wrapper.eq("exam_id", examId);
        wrapper.eq("student_id", studentId);
        return examRecordMapper.selectOne(wrapper);
    }

    public void saveAnswer(Long examId, Long studentId, String answers, String ipAddress) {
        ExamRecord record = getExamRecord(examId, studentId);
        if (record == null) {
            throw new RuntimeException("考试记录不存在");
        }
        record.setAnswers(answers);
        record.setUpdateTime(LocalDateTime.now());
        examRecordMapper.updateById(record);
        logExamAction(examId, studentId, "SAVE_ANSWER", "保存答案", ipAddress);
    }

    public void submitExam(Long examId, Long studentId, String answers, String ipAddress) {
        ExamRecord record = getExamRecord(examId, studentId);
        if (record == null) {
            throw new RuntimeException("考试记录不存在");
        }

        record.setAnswers(answers);
        record.setStatus(Constants.EXAM_STATUS_FINISHED);
        record.setSubmitTime(LocalDateTime.now());
        record.setUpdateTime(LocalDateTime.now());
        examRecordMapper.updateById(record);

        String redisKey = Constants.REDIS_EXAM_PREFIX + examId + ":" + studentId;
        redisTemplate.delete(redisKey);

        logExamAction(examId, studentId, "SUBMIT_EXAM", "提交考试", ipAddress);
    }

    public void logExamAction(Long examId, Long studentId, String action, String detail, String ipAddress) {
        ExamLog log = new ExamLog();
        log.setExamId(examId);
        log.setStudentId(studentId);
        log.setAction(action);
        log.setDetail(detail);
        log.setIpAddress(ipAddress);
        log.setCreateTime(LocalDateTime.now());
        examLogMapper.insert(log);
    }

    public List<ExamLog> getExamLogs(Long examId, Long studentId) {
        QueryWrapper<ExamLog> wrapper = new QueryWrapper<>();
        wrapper.eq("exam_id", examId);
        if (studentId != null) {
            wrapper.eq("student_id", studentId);
        }
        wrapper.orderByDesc("create_time");
        return examLogMapper.selectList(wrapper);
    }

    public List<ExamRecord> getExamRecords(Long examId) {
        QueryWrapper<ExamRecord> wrapper = new QueryWrapper<>();
        wrapper.eq("exam_id", examId);
        return examRecordMapper.selectList(wrapper);
    }

    /**
     * 自动更新考试状态（根据当前时间）
     */
    public void autoUpdateExamStatus() {
        LocalDateTime now = LocalDateTime.now();
        
        // 1. 将已到开始时间但未开始的考试设为进行中
        QueryWrapper<Exam> startWrapper = new QueryWrapper<>();
        startWrapper.eq("status", Constants.EXAM_STATUS_NOT_STARTED)
                   .le("start_time", now)
                   .ge("end_time", now);
        List<Exam> examsToStart = examMapper.selectList(startWrapper);
        
        for (Exam exam : examsToStart) {
            exam.setStatus(Constants.EXAM_STATUS_IN_PROGRESS);
            exam.setUpdateTime(now);
            examMapper.updateById(exam);
        }
        
        // 2. 将已过结束时间的考试设为已结束
        QueryWrapper<Exam> endWrapper = new QueryWrapper<>();
        endWrapper.in("status", Constants.EXAM_STATUS_NOT_STARTED, Constants.EXAM_STATUS_IN_PROGRESS)
                  .lt("end_time", now);
        List<Exam> examsToEnd = examMapper.selectList(endWrapper);
        
        for (Exam exam : examsToEnd) {
            exam.setStatus(Constants.EXAM_STATUS_FINISHED);
            exam.setUpdateTime(now);
            examMapper.updateById(exam);
        }
    }

    /**
     * 手动更新考试状态（管理员强制调节）
     */
    public void updateExamStatus(Long examId, String newStatus) {
        if (!isValidStatus(newStatus)) {
            throw new RuntimeException("无效的考试状态: " + newStatus);
        }
        
        Exam exam = examMapper.selectById(examId);
        if (exam == null) {
            throw new RuntimeException("考试不存在");
        }
        
        String oldStatus = exam.getStatus();
        if (!isValidStatusTransition(oldStatus, newStatus)) {
            throw new RuntimeException("无效的状态转换: " + oldStatus + " -> " + newStatus);
        }
        
        exam.setStatus(newStatus);
        exam.setUpdateTime(LocalDateTime.now());
        examMapper.updateById(exam);
    }

    /**
     * 批量更新考试状态
     */
    public void batchUpdateExamStatus(List<Long> examIds, String newStatus) {
        if (!isValidStatus(newStatus)) {
            throw new RuntimeException("无效的考试状态: " + newStatus);
        }
        
        for (Long examId : examIds) {
            try {
                updateExamStatus(examId, newStatus);
            } catch (Exception e) {
                // 记录日志但继续处理其他考试
                System.err.println("更新考试 " + examId + " 状态失败: " + e.getMessage());
            }
        }
    }

    /**
     * 验证状态是否有效
     */
    private boolean isValidStatus(String status) {
        return Constants.EXAM_STATUS_NOT_STARTED.equals(status)
            || Constants.EXAM_STATUS_IN_PROGRESS.equals(status)
            || Constants.EXAM_STATUS_FINISHED.equals(status);
    }

    /**
     * 验证状态转换是否合法
     */
    private boolean isValidStatusTransition(String oldStatus, String newStatus) {
        // 未开始 -> 进行中/已结束
        if (Constants.EXAM_STATUS_NOT_STARTED.equals(oldStatus)) {
            return Constants.EXAM_STATUS_IN_PROGRESS.equals(newStatus)
                || Constants.EXAM_STATUS_FINISHED.equals(newStatus);
        }
        // 进行中 -> 已结束
        if (Constants.EXAM_STATUS_IN_PROGRESS.equals(oldStatus)) {
            return Constants.EXAM_STATUS_FINISHED.equals(newStatus);
        }
        // 已结束不能转换到其他状态
        return false;
    }

    /**
     * 获取需要自动更新状态的考试列表（用于定时任务）
     */
    public List<Exam> getExamsNeedStatusUpdate() {
        LocalDateTime now = LocalDateTime.now();
        QueryWrapper<Exam> wrapper = new QueryWrapper<>();
        wrapper.ne("status", Constants.EXAM_STATUS_FINISHED)
               .and(w -> w.le("start_time", now).or().lt("end_time", now));
        return examMapper.selectList(wrapper);
    }
}

