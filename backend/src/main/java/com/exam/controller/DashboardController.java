package com.exam.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.exam.common.Result;
import com.exam.entity.*;
import com.exam.mapper.*;
import com.exam.service.ExamService;
import com.exam.service.QuestionService;
import com.exam.service.ScoreService;
import com.exam.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/dashboard")
public class DashboardController {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private QuestionMapper questionMapper;

    @Autowired
    private ExamMapper examMapper;

    @Autowired
    private PaperMapper paperMapper;

    @Autowired
    private ExamRecordMapper examRecordMapper;

    @Autowired
    private ScoreMapper scoreMapper;

    @Autowired
    private QuestionService questionService;

    @Autowired
    private ExamService examService;

    @Autowired
    private ScoreService scoreService;

    @Autowired
    private UserService userService;

    @GetMapping("/statistics")
    public Result<Map<String, Object>> getStatistics(Authentication authentication) {
        System.out.println("========== Dashboard统计API调用开始 ==========");
        String username = authentication.getName();
        User currentUser = userService.getCurrentUser(username);
        System.out.println("当前用户: " + username + ", 角色: " + currentUser.getRole() + ", ID: " + currentUser.getId());
        
        // 如果是学生，返回个人统计数据
        if ("STUDENT".equals(currentUser.getRole())) {
            return getStudentStatistics(currentUser.getId());
        }
        
        // 教师和管理员返回系统全局统计
        return getSystemStatistics();
    }
    
    private Result<Map<String, Object>> getStudentStatistics(Long studentId) {
        System.out.println("========== 学生个人统计 ==========");
        System.out.println("学生ID: " + studentId);
        
        Map<String, Object> stats = new HashMap<>();
        
        // 学生个人考试记录统计
        QueryWrapper<ExamRecord> recordWrapper = new QueryWrapper<>();
        recordWrapper.eq("student_id", studentId);
        long totalExamRecords = examRecordMapper.selectCount(recordWrapper);
        
        QueryWrapper<ExamRecord> finishedWrapper = new QueryWrapper<>();
        finishedWrapper.eq("student_id", studentId);
        finishedWrapper.eq("status", "FINISHED");
        long finishedExamRecords = examRecordMapper.selectCount(finishedWrapper);
        
        QueryWrapper<ExamRecord> inProgressWrapper = new QueryWrapper<>();
        inProgressWrapper.eq("student_id", studentId);
        inProgressWrapper.eq("status", "IN_PROGRESS");
        long inProgressRecords = examRecordMapper.selectCount(inProgressWrapper);
        
        // 学生个人成绩统计
        QueryWrapper<Score> scoreWrapper = new QueryWrapper<>();
        scoreWrapper.eq("student_id", studentId);
        List<Score> studentScores = scoreMapper.selectList(scoreWrapper);
        
        double avgScore = 0;
        int maxScore = 0;
        int minScore = 100;
        int totalScore = 0;
        int examCount = 0;
        
        if (!studentScores.isEmpty()) {
            // 按考试分组计算总分
            Map<Long, Integer> examScores = new HashMap<>();
            for (Score score : studentScores) {
                examScores.put(score.getExamId(), 
                    examScores.getOrDefault(score.getExamId(), 0) + score.getScore());
            }
            
            List<Integer> totalScores = examScores.values().stream().collect(Collectors.toList());
            if (!totalScores.isEmpty()) {
                examCount = totalScores.size();
                totalScore = totalScores.stream().mapToInt(Integer::intValue).sum();
                avgScore = totalScores.stream().mapToInt(Integer::intValue).average().orElse(0);
                maxScore = totalScores.stream().mapToInt(Integer::intValue).max().orElse(0);
                minScore = totalScores.stream().mapToInt(Integer::intValue).min().orElse(0);
            }
        }
        
        // 学生错题知识点统计（用于图表）
        QueryWrapper<Score> wrongScoreWrapper = new QueryWrapper<>();
        wrongScoreWrapper.eq("student_id", studentId);
        wrongScoreWrapper.eq("status", "WRONG");
        List<Score> wrongScores = scoreMapper.selectList(wrongScoreWrapper);
        
        Map<String, Integer> knowledgePointErrors = new HashMap<>();
        for (Score score : wrongScores) {
            Question question = questionService.getQuestionById(score.getQuestionId());
            if (question != null && question.getKnowledgePoint() != null && !question.getKnowledgePoint().trim().isEmpty()) {
                String kp = question.getKnowledgePoint();
                knowledgePointErrors.put(kp, knowledgePointErrors.getOrDefault(kp, 0) + 1);
            }
        }
        
        // 学生参加的考试状态统计
        QueryWrapper<ExamRecord> examRecordWrapper = new QueryWrapper<>();
        examRecordWrapper.eq("student_id", studentId);
        List<ExamRecord> allRecords = examRecordMapper.selectList(examRecordWrapper);
        
        Map<String, Long> examStatusStats = new HashMap<>();
        examStatusStats.put("NOT_STARTED", 0L);
        examStatusStats.put("IN_PROGRESS", (long) inProgressRecords);
        examStatusStats.put("FINISHED", finishedExamRecords);
        
        // 统计未开始的考试（学生可以看到但未参加的）
        QueryWrapper<Exam> availableExamWrapper = new QueryWrapper<>();
        availableExamWrapper.eq("status", "NOT_STARTED");
        long notStartedExams = examMapper.selectCount(availableExamWrapper);
        examStatusStats.put("NOT_STARTED", notStartedExams);
        
        stats.put("totalExams", totalExamRecords); // 参加的考试总数
        stats.put("finishedExamRecords", finishedExamRecords);
        stats.put("inProgressRecords", inProgressRecords);
        stats.put("totalExamRecords", totalExamRecords);
        stats.put("avgScore", avgScore);
        stats.put("maxScore", maxScore);
        stats.put("minScore", minScore == 100 ? 0 : minScore);
        stats.put("totalScore", totalScore);
        stats.put("examCount", examCount);
        stats.put("knowledgePointErrors", knowledgePointErrors);
        stats.put("examStatusStats", examStatusStats);
        stats.put("wrongQuestionCount", wrongScores.size());
        stats.put("totalQuestionCount", studentScores.size());
        
        System.out.println("学生统计结果: " + stats);
        System.out.println("========== 学生个人统计完成 ==========");
        
        return Result.success(stats);
    }
    
    private Result<Map<String, Object>> getSystemStatistics() {
        System.out.println("========== 系统全局统计 ==========");
        Map<String, Object> stats = new HashMap<>();

        // 基础统计数据
        long totalUsers = userMapper.selectCount(null);
        long totalQuestions = questionMapper.selectCount(null);
        long totalExams = examMapper.selectCount(null);
        long totalPapers = paperMapper.selectCount(null);

        // 按角色统计用户数
        Map<String, Long> userStats = new HashMap<>();
        userStats.put("ADMIN", userMapper.selectCount(new QueryWrapper<User>().eq("role", "ADMIN")));
        userStats.put("TEACHER", userMapper.selectCount(new QueryWrapper<User>().eq("role", "TEACHER")));
        userStats.put("STUDENT", userMapper.selectCount(new QueryWrapper<User>().eq("role", "STUDENT")));

        // 按题型统计题目数
        Map<String, Long> questionTypeStats = new HashMap<>();
        questionTypeStats.put("SINGLE", questionMapper.selectCount(new QueryWrapper<Question>().eq("type", "SINGLE")));
        questionTypeStats.put("MULTIPLE", questionMapper.selectCount(new QueryWrapper<Question>().eq("type", "MULTIPLE")));
        questionTypeStats.put("JUDGE", questionMapper.selectCount(new QueryWrapper<Question>().eq("type", "JUDGE")));
        questionTypeStats.put("FILL", questionMapper.selectCount(new QueryWrapper<Question>().eq("type", "FILL")));
        questionTypeStats.put("ESSAY", questionMapper.selectCount(new QueryWrapper<Question>().eq("type", "ESSAY")));

        // 按难度统计题目数
        Map<String, Long> questionDifficultyStats = new HashMap<>();
        questionDifficultyStats.put("EASY", questionMapper.selectCount(new QueryWrapper<Question>().eq("difficulty", "EASY")));
        questionDifficultyStats.put("MEDIUM", questionMapper.selectCount(new QueryWrapper<Question>().eq("difficulty", "MEDIUM")));
        questionDifficultyStats.put("HARD", questionMapper.selectCount(new QueryWrapper<Question>().eq("difficulty", "HARD")));

        // 按状态统计考试数
        Map<String, Long> examStatusStats = new HashMap<>();
        examStatusStats.put("NOT_STARTED", examMapper.selectCount(new QueryWrapper<Exam>().eq("status", "NOT_STARTED")));
        examStatusStats.put("IN_PROGRESS", examMapper.selectCount(new QueryWrapper<Exam>().eq("status", "IN_PROGRESS")));
        examStatusStats.put("FINISHED", examMapper.selectCount(new QueryWrapper<Exam>().eq("status", "FINISHED")));

        // 考试记录统计
        long totalExamRecords = examRecordMapper.selectCount(null);
        long finishedExamRecords = examRecordMapper.selectCount(new QueryWrapper<ExamRecord>().eq("status", "FINISHED"));

        // 成绩统计
        List<Score> allScores = scoreMapper.selectList(null);
        double avgScore = 0;
        int maxScore = 0;
        int minScore = 100;
        if (!allScores.isEmpty()) {
            Map<Long, Integer> examScores = new HashMap<>();
            for (Score score : allScores) {
                examScores.put(score.getExamId(), examScores.getOrDefault(score.getExamId(), 0) + score.getScore());
            }
            List<Integer> totalScores = examScores.values().stream().collect(Collectors.toList());
            if (!totalScores.isEmpty()) {
                avgScore = totalScores.stream().mapToInt(Integer::intValue).average().orElse(0);
                maxScore = totalScores.stream().mapToInt(Integer::intValue).max().orElse(0);
                minScore = totalScores.stream().mapToInt(Integer::intValue).min().orElse(0);
            }
        }

        stats.put("totalUsers", totalUsers);
        stats.put("totalQuestions", totalQuestions);
        stats.put("totalExams", totalExams);
        stats.put("totalPapers", totalPapers);
        stats.put("userStats", userStats);
        stats.put("questionTypeStats", questionTypeStats);
        stats.put("questionDifficultyStats", questionDifficultyStats);
        stats.put("examStatusStats", examStatusStats);
        stats.put("totalExamRecords", totalExamRecords);
        stats.put("finishedExamRecords", finishedExamRecords);
        stats.put("avgScore", avgScore);
        stats.put("maxScore", maxScore);
        stats.put("minScore", minScore);
        
        System.out.println("系统统计结果: " + stats);
        System.out.println("========== 系统全局统计完成 ==========");

        return Result.success(stats);
    }
}

