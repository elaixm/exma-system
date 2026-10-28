package com.exam.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("exams")
public class Exam {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String title;
    private String description;
    private Long paperId;
    private String status;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Integer duration;
    private String token;
    private Long createBy;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}

