package com.exam.service;

import com.exam.entity.Question;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class GeneticAlgorithmService {

    private static final int POPULATION_SIZE = 50;
    private static final int MAX_GENERATIONS = 100;
    private static final double CROSSOVER_RATE = 0.8;
    private static final double MUTATION_RATE = 0.1;

    public List<List<Long>> generateMultiplePapers(List<Question> allQuestions, int paperCount, 
                                                   int targetScore, Map<String, Integer> difficultyDistribution,
                                                   Set<String> requiredKnowledgePoints) {
        List<List<Long>> papers = new ArrayList<>();
        Set<String> usedCombinations = new HashSet<>();

        for (int i = 0; i < paperCount; i++) {
            List<Long> paper = generatePaper(allQuestions, targetScore, difficultyDistribution, requiredKnowledgePoints, usedCombinations);
            if (paper != null) {
                papers.add(paper);
                String combination = paper.stream().sorted().map(String::valueOf).collect(Collectors.joining(","));
                usedCombinations.add(combination);
            }
        }

        return papers;
    }

    private List<Long> generatePaper(List<Question> allQuestions, int targetScore,
                                    Map<String, Integer> difficultyDistribution,
                                    Set<String> requiredKnowledgePoints,
                                    Set<String> usedCombinations) {
        List<Individual> population = initializePopulation(allQuestions, targetScore, difficultyDistribution, requiredKnowledgePoints);

        for (int generation = 0; generation < MAX_GENERATIONS; generation++) {
            population.sort(Comparator.comparingDouble(Individual::getFitness).reversed());

            if (population.get(0).getFitness() > 0.95) {
                List<Long> solution = population.get(0).getQuestionIds();
                String combination = solution.stream().sorted().map(String::valueOf).collect(Collectors.joining(","));
                if (!usedCombinations.contains(combination)) {
                    return solution;
                }
            }

            List<Individual> newPopulation = new ArrayList<>();
            newPopulation.add(population.get(0));

            while (newPopulation.size() < POPULATION_SIZE) {
                Individual parent1 = tournamentSelection(population);
                Individual parent2 = tournamentSelection(population);

                if (Math.random() < CROSSOVER_RATE) {
                    Individual[] offspring = crossover(parent1, parent2, allQuestions, targetScore, difficultyDistribution, requiredKnowledgePoints);
                    newPopulation.add(offspring[0]);
                    if (newPopulation.size() < POPULATION_SIZE) {
                        newPopulation.add(offspring[1]);
                    }
                } else {
                    newPopulation.add(parent1);
                    if (newPopulation.size() < POPULATION_SIZE) {
                        newPopulation.add(parent2);
                    }
                }
            }

            for (int i = 1; i < newPopulation.size(); i++) {
                if (Math.random() < MUTATION_RATE) {
                    mutate(newPopulation.get(i), allQuestions, targetScore, difficultyDistribution, requiredKnowledgePoints);
                }
            }

            population = newPopulation;
        }

        population.sort(Comparator.comparingDouble(Individual::getFitness).reversed());
        List<Long> bestSolution = population.get(0).getQuestionIds();
        String combination = bestSolution.stream().sorted().map(String::valueOf).collect(Collectors.joining(","));
        if (!usedCombinations.contains(combination)) {
            return bestSolution;
        }

        return null;
    }

    private List<Individual> initializePopulation(List<Question> allQuestions, int targetScore,
                                                  Map<String, Integer> difficultyDistribution,
                                                  Set<String> requiredKnowledgePoints) {
        List<Individual> population = new ArrayList<>();
        for (int i = 0; i < POPULATION_SIZE; i++) {
            Individual individual = new Individual();
            List<Long> questionIds = new ArrayList<>();
            int currentScore = 0;
            Set<String> coveredKnowledgePoints = new HashSet<>();
            Map<String, Integer> currentDifficulty = new HashMap<>();

            Collections.shuffle(allQuestions);
            for (Question q : allQuestions) {
                if (currentScore + q.getScore() <= targetScore * 1.1) {
                    questionIds.add(q.getId());
                    currentScore += q.getScore();
                    coveredKnowledgePoints.add(q.getKnowledgePoint());
                    currentDifficulty.put(q.getDifficulty(), currentDifficulty.getOrDefault(q.getDifficulty(), 0) + 1);
                    if (currentScore >= targetScore * 0.9) {
                        break;
                    }
                }
            }
            individual.setQuestionIds(questionIds);
            individual.setFitness(calculateFitness(questionIds, allQuestions, targetScore, difficultyDistribution, requiredKnowledgePoints));
            population.add(individual);
        }
        return population;
    }

    private double calculateFitness(List<Long> questionIds, List<Question> allQuestions, int targetScore,
                                   Map<String, Integer> difficultyDistribution,
                                   Set<String> requiredKnowledgePoints) {
        Map<Long, Question> questionMap = allQuestions.stream().collect(Collectors.toMap(Question::getId, q -> q));
        int totalScore = 0;
        Set<String> coveredKnowledgePoints = new HashSet<>();
        Map<String, Integer> currentDifficulty = new HashMap<>();

        for (Long id : questionIds) {
            Question q = questionMap.get(id);
            if (q != null) {
                totalScore += q.getScore();
                coveredKnowledgePoints.add(q.getKnowledgePoint());
                currentDifficulty.put(q.getDifficulty(), currentDifficulty.getOrDefault(q.getDifficulty(), 0) + 1);
            }
        }

        double scoreFitness = 1.0 - Math.abs(totalScore - targetScore) / (double) targetScore;
        scoreFitness = Math.max(0, Math.min(1, scoreFitness));

        double knowledgeFitness = requiredKnowledgePoints.isEmpty() ? 1.0 :
                (double) coveredKnowledgePoints.size() / requiredKnowledgePoints.size();

        double difficultyFitness = 1.0;
        if (!difficultyDistribution.isEmpty()) {
            double diffSum = 0;
            int total = difficultyDistribution.values().stream().mapToInt(Integer::intValue).sum();
            for (Map.Entry<String, Integer> entry : difficultyDistribution.entrySet()) {
                int expected = entry.getValue();
                int actual = currentDifficulty.getOrDefault(entry.getKey(), 0);
                diffSum += 1.0 - Math.abs(expected - actual) / (double) Math.max(expected, 1);
            }
            difficultyFitness = diffSum / difficultyDistribution.size();
        }

        return (scoreFitness * 0.4 + knowledgeFitness * 0.3 + difficultyFitness * 0.3);
    }

    private Individual tournamentSelection(List<Individual> population) {
        int tournamentSize = 3;
        List<Individual> tournament = new ArrayList<>();
        for (int i = 0; i < tournamentSize; i++) {
            tournament.add(population.get((int) (Math.random() * population.size())));
        }
        tournament.sort(Comparator.comparingDouble(Individual::getFitness).reversed());
        return tournament.get(0);
    }

    private Individual[] crossover(Individual parent1, Individual parent2, List<Question> allQuestions,
                                   int targetScore, Map<String, Integer> difficultyDistribution,
                                   Set<String> requiredKnowledgePoints) {
        Set<Long> combined = new HashSet<>(parent1.getQuestionIds());
        combined.addAll(parent2.getQuestionIds());
        List<Long> combinedList = new ArrayList<>(combined);
        Collections.shuffle(combinedList);

        Individual child1 = new Individual();
        Individual child2 = new Individual();
        List<Long> child1Ids = new ArrayList<>();
        List<Long> child2Ids = new ArrayList<>();

        Map<Long, Question> questionMap = allQuestions.stream().collect(Collectors.toMap(Question::getId, q -> q));
        int score1 = 0, score2 = 0;

        for (Long id : combinedList) {
            Question q = questionMap.get(id);
            if (q == null) continue;

            if (score1 < targetScore && Math.random() < 0.5) {
                child1Ids.add(id);
                score1 += q.getScore();
            }
            if (score2 < targetScore) {
                child2Ids.add(id);
                score2 += q.getScore();
            }
        }

        child1.setQuestionIds(child1Ids);
        child1.setFitness(calculateFitness(child1Ids, allQuestions, targetScore, difficultyDistribution, requiredKnowledgePoints));
        child2.setQuestionIds(child2Ids);
        child2.setFitness(calculateFitness(child2Ids, allQuestions, targetScore, difficultyDistribution, requiredKnowledgePoints));

        return new Individual[]{child1, child2};
    }

    private void mutate(Individual individual, List<Question> allQuestions, int targetScore,
                       Map<String, Integer> difficultyDistribution,
                       Set<String> requiredKnowledgePoints) {
        List<Long> questionIds = new ArrayList<>(individual.getQuestionIds());
        Map<Long, Question> questionMap = allQuestions.stream().collect(Collectors.toMap(Question::getId, q -> q));

        if (Math.random() < 0.5 && !questionIds.isEmpty()) {
            questionIds.remove((int) (Math.random() * questionIds.size()));
        }

        List<Question> available = allQuestions.stream()
                .filter(q -> !questionIds.contains(q.getId()))
                .collect(Collectors.toList());
        Collections.shuffle(available);

        int currentScore = questionIds.stream().mapToInt(id -> questionMap.getOrDefault(id, new Question()).getScore()).sum();
        for (Question q : available) {
            if (currentScore + q.getScore() <= targetScore * 1.1) {
                questionIds.add(q.getId());
                currentScore += q.getScore();
                if (currentScore >= targetScore * 0.9) {
                    break;
                }
            }
        }

        individual.setQuestionIds(questionIds);
        individual.setFitness(calculateFitness(questionIds, allQuestions, targetScore, difficultyDistribution, requiredKnowledgePoints));
    }

    private static class Individual {
        private List<Long> questionIds;
        private double fitness;

        public List<Long> getQuestionIds() {
            return questionIds;
        }

        public void setQuestionIds(List<Long> questionIds) {
            this.questionIds = questionIds;
        }

        public double getFitness() {
            return fitness;
        }

        public void setFitness(double fitness) {
            this.fitness = fitness;
        }
    }
}

