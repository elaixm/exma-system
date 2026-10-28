package com.exam.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("exam_logs")
public class ExamLog {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long examId;
    private Long studentId;
    private String action;
    private String detail;
    private String ipAddress;
    private LocalDateTime createTime;
}

