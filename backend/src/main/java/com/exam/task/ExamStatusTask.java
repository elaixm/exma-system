package com.exam.task;

import com.exam.service.ExamService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * 考试状态定时更新任务
 * 自动根据时间更新考试状态：未开始 -> 进行中 -> 已结束
 */
@Component
public class ExamStatusTask {

    @Autowired
    private ExamService examService;

    /**
     * 每分钟检查一次考试状态
     * 可根据实际需求调整频率
     */
    @Scheduled(cron = "0 * * * * ?")
    public void autoUpdateExamStatus() {
        System.out.println("开始执行考试状态自动更新任务...");
        try {
            examService.autoUpdateExamStatus();
            System.out.println("考试状态自动更新任务执行完成");
        } catch (Exception e) {
            System.err.println("考试状态自动更新任务执行失败: " + e.getMessage());
        }
    }
}
