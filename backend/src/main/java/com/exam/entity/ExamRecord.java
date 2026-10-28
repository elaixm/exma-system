package com.exam.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("exam_records")
public class ExamRecord {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long examId;
    private Long studentId;
    private String answers;
    private Integer score;
    private String status;
    private String ipAddress;
    private LocalDateTime startTime;
    private LocalDateTime submitTime;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}

