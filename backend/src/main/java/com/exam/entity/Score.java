package com.exam.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("scores")
public class Score {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long examId;
    private Long studentId;
    private Long questionId;
    private String studentAnswer;
    private String correctAnswer;
    private Integer score;
    private Integer fullScore;
    private String status;
    private String comment;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}

