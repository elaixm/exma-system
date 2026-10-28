package com.exam.dto;

import com.alibaba.excel.annotation.ExcelProperty;
import lombok.Data;

@Data
public class QuestionImportDTO {
    @ExcelProperty("题型")
    private String type;

    @ExcelProperty("题目内容")
    private String content;

    @ExcelProperty("选项")
    private String options;

    @ExcelProperty("正确答案")
    private String answer;

    @ExcelProperty("解析")
    private String analysis;

    @ExcelProperty("分值")
    private Integer score;

    @ExcelProperty("难度")
    private String difficulty;

    @ExcelProperty("知识点")
    private String knowledgePoint;
}

