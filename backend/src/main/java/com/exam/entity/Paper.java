package com.exam.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("papers")
public class Paper {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String title;
    private String description;
    private String type;
    private String questionIds;
    private Integer totalScore;
    private Integer duration;
    private Long createBy;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}

