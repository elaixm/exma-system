package com.exam.controller;

import com.alibaba.excel.EasyExcel;
import com.alibaba.excel.context.AnalysisContext;
import com.alibaba.excel.read.listener.ReadListener;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.exam.common.Result;
import com.exam.dto.QuestionExportDTO;
import com.exam.dto.QuestionImportDTO;
import com.exam.entity.Question;
import com.exam.service.FileService;
import com.exam.service.QuestionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/questions")
public class QuestionController {

    @Autowired
    private QuestionService questionService;

    @Autowired
    private FileService fileService;

    @GetMapping("/list")
    public Result<Page<Question>> getQuestionList(@RequestParam(defaultValue = "1") Integer page,
                                                  @RequestParam(defaultValue = "10") Integer size,
                                                  @RequestParam(required = false) String type,
                                                  @RequestParam(required = false) String keyword) {
        Page<Question> questionPage = questionService.getQuestionList(page, size, type, keyword);
        return Result.success(questionPage);
    }

    @GetMapping("/{id}")
    public Result<Question> getQuestionById(@PathVariable Long id) {
        Question question = questionService.getQuestionById(id);
        return Result.success(question);
    }

    @PostMapping
    public Result<Void> saveQuestion(@RequestBody Question question) {
        try {
            questionService.saveQuestion(question);
            return Result.success("保存成功", null);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public Result<Void> updateQuestion(@PathVariable Long id, @RequestBody Question question) {
        try {
            question.setId(id);
            questionService.saveQuestion(question);
            return Result.success("更新成功", null);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public Result<Void> deleteQuestion(@PathVariable Long id) {
        try {
            questionService.deleteQuestion(id);
            return Result.success("删除成功", null);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @PostMapping("/batch-import")
    public Result<Void> batchImport(@RequestParam("file") MultipartFile file) {
        try {
            if (file.isEmpty()) {
                return Result.error("文件为空");
            }

            // 保存上传的文件
            String filePath = fileService.uploadFile(file, "questions");
            
            // 读取Excel文件
            List<Question> questions = new ArrayList<>();
            EasyExcel.read(file.getInputStream(), QuestionImportDTO.class, new ReadListener<QuestionImportDTO>() {
                @Override
                public void invoke(QuestionImportDTO data, AnalysisContext context) {
                    Question question = new Question();
                    question.setType(data.getType());
                    question.setContent(data.getContent());
                    question.setOptions(data.getOptions());
                    question.setAnswer(data.getAnswer());
                    question.setAnalysis(data.getAnalysis());
                    question.setScore(data.getScore() != null ? data.getScore() : 5);
                    question.setDifficulty(data.getDifficulty());
                    question.setKnowledgePoint(data.getKnowledgePoint());
                    question.setCreateTime(LocalDateTime.now());
                    questions.add(question);
                }

                @Override
                public void doAfterAllAnalysed(AnalysisContext context) {
                    // 批量保存
                    for (Question question : questions) {
                        questionService.saveQuestion(question);
                    }
                }
            }).sheet().doRead();

            return Result.success("导入成功，共导入 " + questions.size() + " 道题目", null);
        } catch (Exception e) {
            return Result.error("导入失败: " + e.getMessage());
        }
    }

    @GetMapping("/export")
    public void export(HttpServletResponse response) {
        try {
            List<Question> questions = questionService.getAllQuestions();
            
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setCharacterEncoding("utf-8");
            String fileName = URLEncoder.encode("题库导出", "UTF-8").replaceAll("\\+", "%20");
            response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");

            List<QuestionExportDTO> exportData = new ArrayList<>();
            for (Question question : questions) {
                QuestionExportDTO dto = new QuestionExportDTO();
                dto.setType(question.getType());
                dto.setContent(question.getContent());
                dto.setOptions(question.getOptions());
                dto.setAnswer(question.getAnswer());
                dto.setAnalysis(question.getAnalysis());
                dto.setScore(question.getScore());
                dto.setDifficulty(question.getDifficulty());
                dto.setKnowledgePoint(question.getKnowledgePoint());
                exportData.add(dto);
            }

            EasyExcel.write(response.getOutputStream(), QuestionExportDTO.class)
                    .sheet("题库")
                    .doWrite(exportData);
        } catch (Exception e) {
            throw new RuntimeException("导出失败: " + e.getMessage());
        }
    }

    @GetMapping("/all")
    public Result<List<Question>> getAllQuestions() {
        List<Question> questions = questionService.getAllQuestions();
        return Result.success(questions);
    }
}

