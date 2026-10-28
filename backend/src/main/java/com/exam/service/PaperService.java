package com.exam.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.exam.entity.Paper;
import com.exam.mapper.PaperMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class PaperService {

    @Autowired
    private PaperMapper paperMapper;

    @Autowired
    private QuestionService questionService;

    public Page<Paper> getPaperList(Integer page, Integer size, String keyword) {
        Page<Paper> pageObj = new Page<>(page, size);
        QueryWrapper<Paper> wrapper = new QueryWrapper<>();
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like("title", keyword);
        }
        return paperMapper.selectPage(pageObj, wrapper);
    }

    public Paper getPaperById(Long id) {
        return paperMapper.selectById(id);
    }

    public void savePaper(Paper paper) {
        if (paper.getId() == null) {
            paper.setCreateTime(LocalDateTime.now());
            paperMapper.insert(paper);
        } else {
            paper.setUpdateTime(LocalDateTime.now());
            paperMapper.updateById(paper);
        }
    }

    public void deletePaper(Long id) {
        paperMapper.deleteById(id);
    }

    public List<Long> getQuestionIdsFromPaper(Long paperId) {
        Paper paper = paperMapper.selectById(paperId);
        if (paper == null || paper.getQuestionIds() == null) {
            return List.of();
        }
        return Arrays.stream(paper.getQuestionIds().split(","))
                .map(Long::parseLong)
                .collect(Collectors.toList());
    }
}

