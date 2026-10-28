package com.exam.controller;

import com.exam.common.Result;
import com.exam.entity.Score;
import com.exam.entity.User;
import com.exam.service.ScoreService;
import com.exam.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/scores")
public class ScoreController {

    @Autowired
    private ScoreService scoreService;

    @Autowired
    private UserService userService;

    @GetMapping("/exam/{examId}")
    public Result<List<Score>> getScoresByExam(@PathVariable Long examId) {
        List<Score> scores = scoreService.getScoresByExam(examId);
        return Result.success(scores);
    }

    @GetMapping("/exam/{examId}/student/{studentId}")
    public Result<List<Score>> getScoresByStudent(@PathVariable Long examId, @PathVariable Long studentId) {
        List<Score> scores = scoreService.getScoresByStudent(examId, studentId);
        return Result.success(scores);
    }

    @PutMapping("/{id}/grade")
    public Result<Void> updateSubjectiveScore(@PathVariable Long id, @RequestBody Map<String, Object> params,
                                               Authentication authentication) {
        try {
            // 权限校验：只有管理员和教师可以批改
            String username = authentication.getName();
            User user = userService.getCurrentUser(username);
            if (!"ADMIN".equals(user.getRole()) && !"TEACHER".equals(user.getRole())) {
                return Result.error("无权操作，只有管理员和教师可以批改试卷");
            }

            Integer score = (Integer) params.get("score");
            String comment = (String) params.get("comment");
            scoreService.updateSubjectiveScore(id, score, comment);
            return Result.success("评分成功", null);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @GetMapping("/knowledge-graph/{studentId}")
    public Result<Map<String, Object>> getKnowledgeGraph(@PathVariable Long studentId) {
        System.out.println("========== 知识图谱API调用开始 ==========");
        System.out.println("学生ID: " + studentId);
        try {
            Map<String, Object> graph = scoreService.getKnowledgeGraph(studentId);
            System.out.println("知识图谱数据: " + graph);
            System.out.println("knowledgePoints: " + graph.get("knowledgePoints"));
            System.out.println("analysis: " + graph.get("analysis"));
            System.out.println("========== 知识图谱API调用成功 ==========");
            return Result.success(graph);
        } catch (Exception e) {
            System.out.println("========== 知识图谱API调用异常 ==========");
            System.out.println("异常信息: " + e.getMessage());
            e.printStackTrace();
            return Result.error("获取知识图谱失败: " + e.getMessage());
        }
    }

    @GetMapping("/class-weakness/{examId}")
    public Result<Map<String, Object>> getClassWeakness(@PathVariable Long examId) {
        Map<String, Object> weakness = scoreService.getClassWeakness(examId);
        return Result.success(weakness);
    }

    /**
     * 获取学生错题本（含完整题目详情，按知识点分类统计）
     */
    @GetMapping("/wrong-book")
    public Result<Map<String, Object>> getWrongBook(Authentication authentication,
                                                     @RequestParam(required = false) String knowledgePoint) {
        try {
            String username = authentication.getName();
            User user = userService.getCurrentUser(username);
            Map<String, Object> wrongBook = scoreService.getWrongBook(user.getId(), knowledgePoint);
            return Result.success(wrongBook);
        } catch (Exception e) {
            return Result.error("获取错题本失败: " + e.getMessage());
        }
    }

    /**
     * 获取考试成绩概览（教师/管理员用）
     */
    @GetMapping("/exam-overview")
    public Result<List<Map<String, Object>>> getExamScoreOverview(Authentication authentication) {
        try {
            String username = authentication.getName();
            User user = userService.getCurrentUser(username);
            if (!"ADMIN".equals(user.getRole()) && !"TEACHER".equals(user.getRole())) {
                return Result.error("无权访问，只有管理员和教师可以查看成绩概览");
            }
            List<Map<String, Object>> overview = scoreService.getExamScoreOverview();
            return Result.success(overview);
        } catch (Exception e) {
            return Result.error("获取成绩概览失败: " + e.getMessage());
        }
    }

    /**
     * 获取某学生在某考试中的答题详情（教师/管理员用）
     */
    @GetMapping("/exam/{examId}/student/{studentId}/detail")
    public Result<List<Map<String, Object>>> getStudentExamDetail(@PathVariable Long examId,
                                                                    @PathVariable Long studentId,
                                                                    Authentication authentication) {
        try {
            String username = authentication.getName();
            User user = userService.getCurrentUser(username);
            if (!"ADMIN".equals(user.getRole()) && !"TEACHER".equals(user.getRole())) {
                return Result.error("无权访问，只有管理员和教师可以查看答题详情");
            }
            List<Map<String, Object>> detail = scoreService.getStudentExamDetail(examId, studentId);
            return Result.success(detail);
        } catch (Exception e) {
            return Result.error("获取答题详情失败: " + e.getMessage());
        }
    }
}

