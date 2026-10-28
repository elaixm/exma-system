package com.exam.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("questions")
public class Question {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String type;
    private String content;
    private String options;
    private String answer;
    private String analysis;
    private Integer score;
    private String difficulty;
    private String knowledgePoint;
    private Long createBy;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}

