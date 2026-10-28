package com.exam.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.exam.common.Result;
import com.exam.entity.ExamLog;
import com.exam.entity.User;
import com.exam.mapper.ExamLogMapper;
import com.exam.mapper.UserMapper;
import com.exam.service.ExamService;
import com.exam.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/exam-logs")
public class ExamLogController {

    @Autowired
    private ExamLogMapper examLogMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private UserService userService;

    @Autowired
    private ExamService examService;

    @GetMapping("/list")
    public Result<Page<ExamLog>> getExamLogList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) Long examId,
            @RequestParam(required = false) Long studentId) {
        System.out.println("========== 系统日志查询API调用 ==========");
        System.out.println("页码: " + page + ", 每页大小: " + size);
        System.out.println("考试ID: " + examId + ", 学生ID: " + studentId);

        Page<ExamLog> pageObj = new Page<>(page, size);
        QueryWrapper<ExamLog> wrapper = new QueryWrapper<>();
        
        if (examId != null) {
            wrapper.eq("exam_id", examId);
            System.out.println("筛选条件: exam_id = " + examId);
        }
        
        if (studentId != null) {
            wrapper.eq("student_id", studentId);
            System.out.println("筛选条件: student_id = " + studentId);
        }
        
        wrapper.orderByDesc("create_time");
        Page<ExamLog> result = examLogMapper.selectPage(pageObj, wrapper);
        
        System.out.println("查询结果: 总数=" + result.getTotal() + ", 当前页记录数=" + result.getRecords().size());
        System.out.println("========== 系统日志查询完成 ==========");
        
        return Result.success(result);
    }

    @GetMapping("/{id}")
    public Result<ExamLog> getExamLogById(@PathVariable Long id) {
        ExamLog log = examLogMapper.selectById(id);
        return Result.success(log);
    }

    @PostMapping("/log-action")
    public Result<Void> logAction(@RequestBody Map<String, Object> params,
                                  Authentication authentication,
                                  HttpServletRequest request) {
        try {
            String username = authentication.getName();
            User user = userService.getCurrentUser(username);
            Long examId = Long.valueOf(params.get("examId").toString());
            String action = params.get("action").toString();
            String detail = params.get("detail").toString();
            String ipAddress = getClientIpAddress(request);
            
            examService.logExamAction(examId, user.getId(), action, detail, ipAddress);
            return Result.success("日志记录成功", null);
        } catch (Exception e) {
            return Result.error("日志记录失败: " + e.getMessage());
        }
    }

    @GetMapping("/statistics")
    public Result<Map<String, Object>> getLogStatistics(
            @RequestParam(required = false) Long examId,
            @RequestParam(required = false) Long studentId) {
        QueryWrapper<ExamLog> wrapper = new QueryWrapper<>();
        
        if (examId != null) {
            wrapper.eq("exam_id", examId);
        }
        
        if (studentId != null) {
            wrapper.eq("student_id", studentId);
        }
        
        long totalLogs = examLogMapper.selectCount(wrapper);
        
        // 统计各种操作类型
        Map<String, Long> actionStats = new HashMap<>();
        List<ExamLog> allLogs = examLogMapper.selectList(wrapper);
        for (ExamLog log : allLogs) {
            String action = log.getAction();
            actionStats.put(action, actionStats.getOrDefault(action, 0L) + 1);
        }
        
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalLogs", totalLogs);
        stats.put("actionStats", actionStats);
        
        return Result.success(stats);
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
