package com.exam.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.exam.common.Result;
import com.exam.entity.Exam;
import com.exam.entity.ExamLog;
import com.exam.entity.ExamRecord;
import com.exam.entity.User;
import com.exam.service.ExamService;
import com.exam.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/exams")
public class ExamController {

    @Autowired
    private ExamService examService;

    @Autowired
    private com.exam.service.ExamRecordService examRecordService;

    @Autowired
    private UserService userService;

    @GetMapping("/list")
    public Result<Page<Exam>> getExamList(@RequestParam(defaultValue = "1") Integer page,
                                         @RequestParam(defaultValue = "10") Integer size,
                                         @RequestParam(required = false) String status,
                                         @RequestParam(required = false) String keyword) {
        Page<Exam> examPage = examService.getExamList(page, size, status, keyword);
        return Result.success(examPage);
    }

    @GetMapping("/{id}")
    public Result<Exam> getExamById(@PathVariable Long id) {
        Exam exam = examService.getExamById(id);
        return Result.success(exam);
    }

    @PostMapping
    public Result<Exam> createExam(@RequestBody Exam exam) {
        try {
            Exam created = examService.createExam(exam);
            return Result.success(created);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public Result<Void> updateExam(@PathVariable Long id, @RequestBody Exam exam) {
        try {
            exam.setId(id);
            examService.updateExam(exam);
            return Result.success("更新成功", null);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public Result<Void> deleteExam(@PathVariable Long id) {
        try {
            examService.deleteExam(id);
            return Result.success("删除成功", null);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @PostMapping("/{id}/start")
    public Result<ExamRecord> startExam(@PathVariable Long id, Authentication authentication,
                                       HttpServletRequest request) {
        try {
            String username = authentication.getName();
            User user = userService.getCurrentUser(username);
            String ipAddress = getClientIpAddress(request);
            ExamRecord record = examService.startExam(id, user.getId(), ipAddress);
            return Result.success(record);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @GetMapping("/{id}/questions")
    public Result<List<com.exam.entity.Question>> getExamQuestions(@PathVariable Long id,
                                                                    Authentication authentication) {
        try {
            // 校验用户是否有权限获取题目（必须有考试记录）
            String username = authentication.getName();
            User user = userService.getCurrentUser(username);
            com.exam.entity.ExamRecord record = examService.getExamRecord(id, user.getId());
            if (record == null) {
                return Result.error("请先开始考试");
            }
            if (com.exam.common.Constants.EXAM_STATUS_FINISHED.equals(record.getStatus())) {
                return Result.error("考试已提交，无法查看题目");
            }

            List<com.exam.entity.Question> questions = examRecordService.getExamQuestions(id);
            java.util.Collections.shuffle(questions);
            return Result.success(questions);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @PostMapping("/{id}/save-answer")
    public Result<Void> saveAnswer(@PathVariable Long id, @RequestBody Map<String, String> params,
                                   Authentication authentication, HttpServletRequest request) {
        try {
            String username = authentication.getName();
            User user = userService.getCurrentUser(username);
            String answers = params.get("answers");
            String ipAddress = getClientIpAddress(request);
            examService.saveAnswer(id, user.getId(), answers, ipAddress);
            return Result.success("保存成功", null);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @PostMapping("/{id}/submit")
    public Result<Void> submitExam(@PathVariable Long id, @RequestBody Map<String, String> params,
                                   Authentication authentication, HttpServletRequest request) {
        try {
            String username = authentication.getName();
            User user = userService.getCurrentUser(username);
            String answers = params.get("answers");
            String ipAddress = getClientIpAddress(request);
            examService.submitExam(id, user.getId(), answers, ipAddress);
            examService.gradeExam(id, user.getId(), answers);
            return Result.success("提交成功", null);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @GetMapping("/{id}/logs")
    public Result<List<ExamLog>> getExamLogs(@PathVariable Long id,
                                            @RequestParam(required = false) Long studentId) {
        List<ExamLog> logs = examService.getExamLogs(id, studentId);
        return Result.success(logs);
    }

    @GetMapping("/{id}/records")
    public Result<List<ExamRecord>> getExamRecords(@PathVariable Long id,
                                                   @RequestParam(required = false) Long studentId) {
        if (studentId != null) {
            ExamRecord record = examService.getExamRecord(id, studentId);
            return Result.success(record != null ? List.of(record) : List.of());
        }
        List<ExamRecord> records = examService.getExamRecords(id);
        return Result.success(records);
    }

    /**
     * 手动更新考试状态（管理员）
     */
    @PutMapping("/{id}/status")
    public Result<Void> updateExamStatus(@PathVariable Long id, @RequestBody Map<String, String> params) {
        try {
            String newStatus = params.get("status");
            if (newStatus == null || newStatus.isEmpty()) {
                return Result.error("状态不能为空");
            }
            examService.updateExamStatus(id, newStatus);
            return Result.success("状态更新成功", null);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    /**
     * 批量更新考试状态（管理员）
     */
    @PutMapping("/batch-status")
    public Result<Void> batchUpdateExamStatus(@RequestBody Map<String, Object> params) {
        try {
            @SuppressWarnings("unchecked")
            List<Long> examIds = (List<Long>) params.get("examIds");
            String newStatus = (String) params.get("status");
            if (examIds == null || examIds.isEmpty() || newStatus == null) {
                return Result.error("参数不完整");
            }
            examService.batchUpdateExamStatus(examIds, newStatus);
            return Result.success("批量更新成功", null);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    /**
     * 触发自动更新考试状态（可配置定时任务调用）
     */
    @PostMapping("/auto-update-status")
    public Result<Void> autoUpdateExamStatus() {
        try {
            examService.autoUpdateExamStatus();
            return Result.success("状态自动更新完成", null);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    private String getClientIpAddress(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
}

