package com.exam.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.exam.common.Result;
import com.exam.entity.Paper;
import com.exam.service.PaperService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/papers")
public class PaperController {

    @Autowired
    private PaperService paperService;

    @Autowired
    private com.exam.service.GeneticAlgorithmService geneticAlgorithmService;

    @Autowired
    private com.exam.service.QuestionService questionService;

    @GetMapping("/list")
    public Result<Page<Paper>> getPaperList(@RequestParam(defaultValue = "1") Integer page,
                                           @RequestParam(defaultValue = "10") Integer size,
                                           @RequestParam(required = false) String keyword) {
        Page<Paper> paperPage = paperService.getPaperList(page, size, keyword);
        return Result.success(paperPage);
    }

    @GetMapping("/{id}")
    public Result<Paper> getPaperById(@PathVariable Long id) {
        Paper paper = paperService.getPaperById(id);
        return Result.success(paper);
    }

    @PostMapping
    public Result<Paper> savePaper(@RequestBody Paper paper) {
        try {
            paperService.savePaper(paper);
            return Result.success(paper);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public Result<Void> updatePaper(@PathVariable Long id, @RequestBody Paper paper) {
        try {
            paper.setId(id);
            paperService.savePaper(paper);
            return Result.success("更新成功", null);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public Result<Void> deletePaper(@PathVariable Long id) {
        try {
            paperService.deletePaper(id);
            return Result.success("删除成功", null);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    @PostMapping("/generate-random")
    public Result<List<Paper>> generateRandomPapers(@RequestBody Map<String, Object> params) {
        try {
            int paperCount = (Integer) params.get("paperCount");
            int targetScore = (Integer) params.get("targetScore");
            Map<String, Integer> difficultyDistribution = (Map<String, Integer>) params.get("difficultyDistribution");
            List<String> requiredKnowledgePoints = (List<String>) params.get("requiredKnowledgePoints");

            List<com.exam.entity.Question> allQuestions = questionService.getAllQuestions();
            List<List<Long>> paperQuestionIds = geneticAlgorithmService.generateMultiplePapers(
                    allQuestions, paperCount, targetScore, difficultyDistribution,
                    requiredKnowledgePoints != null ? new java.util.HashSet<>(requiredKnowledgePoints) : new java.util.HashSet<>());

            List<Paper> papers = new java.util.ArrayList<>();
            for (int i = 0; i < paperQuestionIds.size(); i++) {
                Paper paper = new Paper();
                paper.setTitle("随机试卷" + (i + 1));
                paper.setType("RANDOM");
                paper.setQuestionIds(String.join(",", paperQuestionIds.get(i).stream().map(String::valueOf).toList()));
                int totalScore = paperQuestionIds.get(i).stream()
                        .mapToInt(id -> allQuestions.stream().filter(q -> q.getId().equals(id))
                                .findFirst().map(com.exam.entity.Question::getScore).orElse(0))
                        .sum();
                paper.setTotalScore(totalScore);
                paperService.savePaper(paper);
                papers.add(paper);
            }

            return Result.success(papers);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
}

