package com.exam.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.exam.entity.Exam;
import com.exam.entity.ExamRecord;
import com.exam.entity.Paper;
import com.exam.entity.Question;
import com.exam.mapper.ExamRecordMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ExamRecordService {

    @Autowired
    private ExamRecordMapper examRecordMapper;

    @Autowired
    private PaperService paperService;

    @Autowired
    private QuestionService questionService;

    public ExamRecord getExamRecord(Long examId, Long studentId) {
        QueryWrapper<ExamRecord> wrapper = new QueryWrapper<>();
        wrapper.eq("exam_id", examId);
        wrapper.eq("student_id", studentId);
        return examRecordMapper.selectOne(wrapper);
    }

    public void updateScore(Long examId, Long studentId, Integer score) {
        ExamRecord record = getExamRecord(examId, studentId);
        if (record != null) {
            record.setScore(score);
            record.setUpdateTime(LocalDateTime.now());
            examRecordMapper.updateById(record);
        }
    }

    public List<Question> getExamQuestions(Long examId) {
        Exam exam = examService.getExamById(examId);
        if (exam == null) {
            return List.of();
        }
        Paper paper = paperService.getPaperById(exam.getPaperId());
        if (paper == null) {
            return List.of();
        }
        List<Long> questionIds = paperService.getQuestionIdsFromPaper(paper.getId());
        return questionService.getQuestionsByIds(questionIds);
    }

    @Autowired
    @Lazy
    private ExamService examService;

    /**
     * 获取所有考试记录
     */
    public List<ExamRecord> getAllRecords() {
        return examRecordMapper.selectList(null);
    }

    /**
     * 根据考试ID获取考试信息
     */
    public Exam getExamById(Long examId) {
        return examService.getExamById(examId);
    }
}

