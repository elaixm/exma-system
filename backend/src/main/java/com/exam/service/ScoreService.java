package com.exam.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.exam.entity.Exam;
import com.exam.entity.ExamRecord;
import com.exam.entity.Question;
import com.exam.entity.Score;
import com.exam.entity.User;
import com.exam.mapper.ScoreMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class ScoreService {

    @Autowired
    private ScoreMapper scoreMapper;

    @Autowired
    private QuestionService questionService;

    @Autowired
    private ExamRecordService examRecordService;

    @Autowired
    private UserService userService;

    public void gradeExam(Long examId, Long studentId, String answers) {
        List<Question> questions = examRecordService.getExamQuestions(examId);
        Map<Long, Question> questionMap = questions.stream().collect(Collectors.toMap(Question::getId, q -> q));

        Map<Long, String> answerMap = parseAnswers(answers);

        int totalScore = 0;
        for (Map.Entry<Long, String> entry : answerMap.entrySet()) {
            Long questionId = entry.getKey();
            String studentAnswer = entry.getValue();
            Question question = questionMap.get(questionId);

            if (question == null) continue;

            Score score = new Score();
            score.setExamId(examId);
            score.setStudentId(studentId);
            score.setQuestionId(questionId);
            score.setStudentAnswer(studentAnswer);
            score.setCorrectAnswer(question.getAnswer());
            score.setFullScore(question.getScore());

            boolean isCorrect = checkAnswer(question, studentAnswer);
            if (isCorrect) {
                score.setScore(question.getScore());
                totalScore += question.getScore();
                score.setStatus("CORRECT");
            } else if ("ESSAY".equals(question.getType())) {
                // 主观题无法自动批改，标记为待批改，不计入总分
                score.setScore(0);
                score.setStatus("PENDING");
            } else {
                score.setScore(0);
                score.setStatus("WRONG");
            }

            score.setCreateTime(LocalDateTime.now());
            score.setUpdateTime(LocalDateTime.now());
            scoreMapper.insert(score);
        }

        examRecordService.updateScore(examId, studentId, totalScore);
    }

    private Map<Long, String> parseAnswers(String answers) {
        Map<Long, String> answerMap = new HashMap<>();
        if (answers == null || answers.isEmpty()) {
            return answerMap;
        }
        String[] pairs = answers.split(";");
        for (String pair : pairs) {
            String[] keyValue = pair.split(":");
            if (keyValue.length == 2) {
                answerMap.put(Long.parseLong(keyValue[0]), keyValue[1]);
            }
        }
        return answerMap;
    }

    private boolean checkAnswer(Question question, String studentAnswer) {
        if (studentAnswer == null || studentAnswer.isEmpty()) {
            return false;
        }

        String correctAnswer = question.getAnswer();
        if (correctAnswer == null) {
            return false;
        }

        switch (question.getType()) {
            case "SINGLE":
            case "JUDGE":
            case "FILL":
                return correctAnswer.trim().equalsIgnoreCase(studentAnswer.trim());
            case "MULTIPLE":
                String[] correct = correctAnswer.split(",");
                String[] student = studentAnswer.split(",");
                Arrays.sort(correct);
                Arrays.sort(student);
                return Arrays.equals(correct, student);
            case "ESSAY":
                return false;
            default:
                return false;
        }
    }

    public List<Score> getScoresByExam(Long examId) {
        QueryWrapper<Score> wrapper = new QueryWrapper<>();
        wrapper.eq("exam_id", examId);
        return scoreMapper.selectList(wrapper);
    }

    public List<Score> getScoresByStudent(Long examId, Long studentId) {
        QueryWrapper<Score> wrapper = new QueryWrapper<>();
        wrapper.eq("exam_id", examId);
        wrapper.eq("student_id", studentId);
        return scoreMapper.selectList(wrapper);
    }

    public void updateSubjectiveScore(Long scoreId, Integer score, String comment) {
        Score scoreObj = scoreMapper.selectById(scoreId);
        if (scoreObj != null) {
            scoreObj.setScore(score);
            scoreObj.setComment(comment);
            // 如果得0分标记为WRONG（错题），得分大于0标记为GRADED（已批改）
            if (score == null || score == 0) {
                scoreObj.setStatus("WRONG");
            } else {
                scoreObj.setStatus("GRADED");
            }
            scoreObj.setUpdateTime(LocalDateTime.now());
            scoreMapper.updateById(scoreObj);
            
            // 重新计算该学生在该考试中的总分
            recalculateTotalScore(scoreObj.getExamId(), scoreObj.getStudentId());
        }
    }

    /**
     * 重新计算某学生在某考试中的总分
     */
    private void recalculateTotalScore(Long examId, Long studentId) {
        QueryWrapper<Score> wrapper = new QueryWrapper<>();
        wrapper.eq("exam_id", examId);
        wrapper.eq("student_id", studentId);
        List<Score> allScores = scoreMapper.selectList(wrapper);
        
        int totalScore = 0;
        for (Score s : allScores) {
            totalScore += (s.getScore() != null ? s.getScore() : 0);
        }
        
        examRecordService.updateScore(examId, studentId, totalScore);
    }

    public Map<String, Object> getKnowledgeGraph(Long studentId) {
        System.out.println("========== ScoreService.getKnowledgeGraph 开始 ==========");
        System.out.println("学生ID: " + studentId);
        
        QueryWrapper<Score> wrapper = new QueryWrapper<>();
        wrapper.eq("student_id", studentId);
        wrapper.eq("status", "WRONG");
        List<Score> wrongScores = scoreMapper.selectList(wrapper);
        
        System.out.println("查询到的错题数量: " + wrongScores.size());
        for (Score score : wrongScores) {
            System.out.println("错题记录 - ID: " + score.getId() + ", 题目ID: " + score.getQuestionId());
        }

        Map<String, Integer> knowledgePointErrors = new HashMap<>();
        Map<Long, String> analysisMap = new HashMap<>();
        
        for (Score score : wrongScores) {
            System.out.println("处理错题记录 - 题目ID: " + score.getQuestionId());
            Question question = questionService.getQuestionById(score.getQuestionId());
            if (question != null) {
                System.out.println("题目信息 - ID: " + question.getId() + ", 知识点: " + question.getKnowledgePoint());
                if (question.getKnowledgePoint() != null && !question.getKnowledgePoint().trim().isEmpty()) {
                    String kp = question.getKnowledgePoint();
                    int count = knowledgePointErrors.getOrDefault(kp, 0) + 1;
                    knowledgePointErrors.put(kp, count);
                    System.out.println("知识点统计 - " + kp + ": " + count);
                }
                if (question.getAnalysis() != null) {
                    analysisMap.put(score.getQuestionId(), question.getAnalysis());
                }
            } else {
                System.out.println("警告: 题目ID " + score.getQuestionId() + " 对应的题目不存在");
            }
        }

        System.out.println("知识点错误统计: " + knowledgePointErrors);
        System.out.println("解析信息数量: " + analysisMap.size());

        Map<String, Object> result = new HashMap<>();
        result.put("knowledgePoints", knowledgePointErrors);
        result.put("analysis", analysisMap);
        
        System.out.println("返回结果: " + result);
        System.out.println("========== ScoreService.getKnowledgeGraph 结束 ==========");
        return result;
    }

    /**
     * 获取学生错题本列表（含题目详情），按知识点分类，同一题多次做错去重
     */
    public Map<String, Object> getWrongBook(Long studentId, String knowledgePoint) {
        QueryWrapper<Score> wrapper = new QueryWrapper<>();
        wrapper.eq("student_id", studentId);
        wrapper.in("status", "WRONG");
        wrapper.orderByDesc("create_time");
        List<Score> wrongScores = scoreMapper.selectList(wrapper);

        // 按题目ID去重，保留最新的错题记录（同一题多次做错只显示最近一次）
        Map<Long, Score> latestWrongMap = new LinkedHashMap<>();
        for (Score score : wrongScores) {
            latestWrongMap.put(score.getQuestionId(), score);
        }

        List<Map<String, Object>> wrongBookList = new ArrayList<>();
        Map<String, Integer> knowledgePointCount = new LinkedHashMap<>();
        Map<String, Map<String, Integer>> knowledgePointTypeCount = new LinkedHashMap<>();

        for (Score score : latestWrongMap.values()) {
            Question question = questionService.getQuestionById(score.getQuestionId());
            if (question == null) continue;

            String kp = question.getKnowledgePoint() != null ? question.getKnowledgePoint() : "未分类";

            // 如果指定了知识点筛选，跳过不匹配的
            if (knowledgePoint != null && !knowledgePoint.isEmpty()
                && !knowledgePoint.equals(kp)) {
                continue;
            }

            Map<String, Object> item = new HashMap<>();
            item.put("scoreId", score.getId());
            item.put("examId", score.getExamId());
            item.put("studentAnswer", score.getStudentAnswer());
            item.put("correctAnswer", score.getCorrectAnswer());
            item.put("score", score.getScore());
            item.put("fullScore", score.getFullScore());
            item.put("wrongTime", score.getCreateTime());

            // 题目详情
            item.put("questionId", question.getId());
            item.put("questionType", question.getType());
            item.put("questionContent", question.getContent());
            item.put("questionOptions", question.getOptions());
            item.put("questionAnswer", question.getAnswer());
            item.put("questionAnalysis", question.getAnalysis());
            item.put("questionScore", question.getScore());
            item.put("questionDifficulty", question.getDifficulty());
            item.put("knowledgePoint", kp);

            wrongBookList.add(item);

            // 统计知识点错题数
            knowledgePointCount.put(kp, knowledgePointCount.getOrDefault(kp, 0) + 1);

            // 统计知识点下各类型错题数
            knowledgePointTypeCount.computeIfAbsent(kp, k -> new LinkedHashMap<>());
            Map<String, Integer> typeCount = knowledgePointTypeCount.get(kp);
            typeCount.put(question.getType(), typeCount.getOrDefault(question.getType(), 0) + 1);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("wrongList", wrongBookList);
        result.put("knowledgePointCount", knowledgePointCount);
        result.put("knowledgePointTypeCount", knowledgePointTypeCount);
        result.put("totalWrong", latestWrongMap.size());
        return result;
    }

    public Map<String, Object> getClassWeakness(Long examId) {
        List<Score> scores = getScoresByExam(examId);
        Map<String, Integer> knowledgePointErrors = new HashMap<>();
        Map<String, Integer> knowledgePointTotal = new HashMap<>();

        for (Score score : scores) {
            Question question = questionService.getQuestionById(score.getQuestionId());
            if (question != null && question.getKnowledgePoint() != null) {
                String kp = question.getKnowledgePoint();
                knowledgePointTotal.put(kp, knowledgePointTotal.getOrDefault(kp, 0) + 1);
                if ("WRONG".equals(score.getStatus())) {
                    knowledgePointErrors.put(kp, knowledgePointErrors.getOrDefault(kp, 0) + 1);
                }
            }
        }

        Map<String, Double> weaknessMap = new HashMap<>();
        for (String kp : knowledgePointTotal.keySet()) {
            int errors = knowledgePointErrors.getOrDefault(kp, 0);
            int total = knowledgePointTotal.get(kp);
            double rate = total > 0 ? (double) errors / total : 0;
            weaknessMap.put(kp, rate);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("weakness", weaknessMap);
        return result;
    }

    /**
     * 获取考试的成绩概览（教师/管理员用）：考试信息 + 参加学生列表 + 得分 + 待批改数
     */
    public List<Map<String, Object>> getExamScoreOverview() {
        List<ExamRecord> allRecords = examRecordService.getAllRecords();

        // 按考试ID分组
        Map<Long, List<ExamRecord>> recordsByExam = new LinkedHashMap<>();
        for (ExamRecord record : allRecords) {
            recordsByExam.computeIfAbsent(record.getExamId(), k -> new ArrayList<>());
            recordsByExam.get(record.getExamId()).add(record);
        }

        List<Map<String, Object>> overviewList = new ArrayList<>();
        for (Map.Entry<Long, List<ExamRecord>> entry : recordsByExam.entrySet()) {
            Long examId = entry.getKey();
            List<ExamRecord> records = entry.getValue();

            Exam exam = examRecordService.getExamById(examId);
            if (exam == null) continue;

            // 统计待批改数量
            int pendingCount = 0;
            int finishedCount = 0;
            int totalScoreSum = 0;
            int maxScore = 0;
            int minScore = Integer.MAX_VALUE;

            List<Map<String, Object>> studentList = new ArrayList<>();
            for (ExamRecord record : records) {
                Map<String, Object> studentInfo = new HashMap<>();
                studentInfo.put("recordId", record.getId());
                studentInfo.put("studentId", record.getStudentId());
                studentInfo.put("score", record.getScore());
                studentInfo.put("status", record.getStatus());
                studentInfo.put("submitTime", record.getSubmitTime());

                // 查询用户名
                User student = userService.getUserById(record.getStudentId());
                if (student != null) {
                    studentInfo.put("studentName", student.getRealName() != null ? student.getRealName() : student.getUsername());
                    studentInfo.put("username", student.getUsername());
                } else {
                    studentInfo.put("studentName", "未知学生");
                    studentInfo.put("username", "");
                }

                // 该学生待批改数
                QueryWrapper<Score> scoreWrapper = new QueryWrapper<>();
                scoreWrapper.eq("exam_id", examId);
                scoreWrapper.eq("student_id", record.getStudentId());
                scoreWrapper.eq("status", "PENDING");
                Long pending = scoreMapper.selectCount(scoreWrapper);
                studentInfo.put("pendingCount", pending.intValue());
                pendingCount += pending.intValue();

                if ("FINISHED".equals(record.getStatus())) {
                    finishedCount++;
                    int s = record.getScore() != null ? record.getScore() : 0;
                    totalScoreSum += s;
                    if (s > maxScore) maxScore = s;
                    if (s < minScore) minScore = s;
                }

                studentList.add(studentInfo);
            }

            Map<String, Object> examOverview = new HashMap<>();
            examOverview.put("examId", examId);
            examOverview.put("examTitle", exam.getTitle());
            examOverview.put("examStatus", exam.getStatus());
            examOverview.put("startTime", exam.getStartTime());
            examOverview.put("endTime", exam.getEndTime());
            examOverview.put("duration", exam.getDuration());
            examOverview.put("totalStudents", records.size());
            examOverview.put("finishedStudents", finishedCount);
            examOverview.put("pendingCount", pendingCount);
            examOverview.put("avgScore", finishedCount > 0 ? Math.round((double) totalScoreSum / finishedCount * 10) / 10.0 : 0);
            examOverview.put("maxScore", maxScore);
            examOverview.put("minScore", minScore == Integer.MAX_VALUE ? 0 : minScore);
            examOverview.put("students", studentList);

            overviewList.add(examOverview);
        }

        return overviewList;
    }

    /**
     * 获取某学生在某考试中的答题详情（含完整题目信息）
     */
    public List<Map<String, Object>> getStudentExamDetail(Long examId, Long studentId) {
        QueryWrapper<Score> wrapper = new QueryWrapper<>();
        wrapper.eq("exam_id", examId);
        wrapper.eq("student_id", studentId);
        wrapper.orderByAsc("id");
        List<Score> scores = scoreMapper.selectList(wrapper);

        List<Map<String, Object>> detailList = new ArrayList<>();
        for (Score score : scores) {
            Question question = questionService.getQuestionById(score.getQuestionId());

            Map<String, Object> item = new HashMap<>();
            item.put("scoreId", score.getId());
            item.put("studentAnswer", score.getStudentAnswer());
            item.put("correctAnswer", score.getCorrectAnswer());
            item.put("score", score.getScore());
            item.put("fullScore", score.getFullScore());
            item.put("status", score.getStatus());
            item.put("comment", score.getComment());

            if (question != null) {
                item.put("questionId", question.getId());
                item.put("questionType", question.getType());
                item.put("questionContent", question.getContent());
                item.put("questionOptions", question.getOptions());
                item.put("questionAnswer", question.getAnswer());
                item.put("questionAnalysis", question.getAnalysis());
                item.put("questionScore", question.getScore());
                item.put("questionDifficulty", question.getDifficulty());
                item.put("knowledgePoint", question.getKnowledgePoint());
            }

            detailList.add(item);
        }
        return detailList;
    }
}