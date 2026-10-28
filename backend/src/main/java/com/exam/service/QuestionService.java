package com.exam.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.exam.entity.Question;
import com.exam.mapper.QuestionMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class QuestionService {

    @Autowired
    private QuestionMapper questionMapper;

    public Page<Question> getQuestionList(Integer page, Integer size, String type, String keyword) {
        Page<Question> pageObj = new Page<>(page, size);
        QueryWrapper<Question> wrapper = new QueryWrapper<>();
        if (type != null && !type.isEmpty()) {
            wrapper.eq("type", type);
        }
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w.like("content", keyword)
                    .or().like("knowledge_point", keyword));
        }
        return questionMapper.selectPage(pageObj, wrapper);
    }

    public Question getQuestionById(Long id) {
        return questionMapper.selectById(id);
    }

    public void saveQuestion(Question question) {
        if (question.getId() == null) {
            question.setCreateTime(LocalDateTime.now());
            questionMapper.insert(question);
        } else {
            question.setUpdateTime(LocalDateTime.now());
            questionMapper.updateById(question);
        }
    }

    public void deleteQuestion(Long id) {
        questionMapper.deleteById(id);
    }

    public List<Question> getQuestionsByIds(List<Long> ids) {
        return questionMapper.selectBatchIds(ids);
    }

    public List<Question> getAllQuestions() {
        return questionMapper.selectList(null);
    }
}

