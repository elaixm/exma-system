<template>
  <div>
    <!-- ==================== 教师/管理员端 ==================== -->
    <template v-if="isTeacherOrAdmin">
      <!-- 考试成绩概览列表 -->
      <el-card>
        <template #header>
          <div style="display: flex; justify-content: space-between; align-items: center;">
            <span>考试成绩管理</span>
            <el-button type="primary" size="small" @click="loadOverview" :loading="overviewLoading">刷新数据</el-button>
          </div>
        </template>

        <div v-loading="overviewLoading">
          <div v-if="!overviewLoading && examOverviewList.length === 0" style="text-align: center; padding: 50px; color: #909399;">
            暂无考试数据
          </div>

          <div v-for="exam in examOverviewList" :key="exam.examId" class="exam-card">
            <!-- 考试信息头 -->
            <div class="exam-header" @click="toggleExam(exam.examId)">
              <div class="exam-info">
                <h3 style="margin: 0;">{{ exam.examTitle }}</h3>
                <div class="exam-meta">
                  <el-tag size="small" :type="exam.examStatus === 'FINISHED' ? 'info' : exam.examStatus === 'IN_PROGRESS' ? 'success' : 'warning'">
                    {{ getExamStatusName(exam.examStatus) }}
                  </el-tag>
                  <span>时长: {{ exam.duration }}分钟</span>
                  <span>{{ exam.startTime }}</span>
                </div>
              </div>
              <div class="exam-stats">
                <div class="stat-item">
                  <div class="stat-value">{{ exam.totalStudents }}</div>
                  <div class="stat-label">参考人数</div>
                </div>
                <div class="stat-item">
                  <div class="stat-value">{{ exam.finishedStudents }}</div>
                  <div class="stat-label">已提交</div>
                </div>
                <div class="stat-item">
                  <div class="stat-value" style="color: #409EFF;">{{ exam.avgScore }}</div>
                  <div class="stat-label">平均分</div>
                </div>
                <div class="stat-item">
                  <div class="stat-value" style="color: #67C23A;">{{ exam.maxScore }}</div>
                  <div class="stat-label">最高分</div>
                </div>
                <div class="stat-item">
                  <div class="stat-value" style="color: #F56C6C;">{{ exam.minScore }}</div>
                  <div class="stat-label">最低分</div>
                </div>
                <div class="stat-item" v-if="exam.pendingCount > 0">
                  <div class="stat-value" style="color: #E6A23C;">{{ exam.pendingCount }}</div>
                  <div class="stat-label">待批改</div>
                </div>
              </div>
              <el-icon :size="20" style="margin-left: 15px;">
                <ArrowDown v-if="!expandedExams[exam.examId]" />
                <ArrowUp v-else />
              </el-icon>
            </div>

            <!-- 学生列表（展开区域） -->
            <div v-if="expandedExams[exam.examId]" class="student-table-wrap">
              <el-table :data="exam.students" border size="small" style="width: 100%;">
                <el-table-column prop="studentName" label="学生姓名" min-width="120" />
                <el-table-column prop="username" label="用户名" min-width="120" />
                <el-table-column prop="score" label="得分" min-width="80">
                  <template #default="{ row }">
                    <span :style="{ color: row.score !== null && row.score !== undefined ? (row.score >= 60 ? '#67C23A' : '#F56C6C') : '#909399', fontWeight: 'bold' }">
                      {{ row.score !== null && row.score !== undefined ? row.score : '-' }}
                    </span>
                  </template>
                </el-table-column>
                <el-table-column prop="status" label="状态" min-width="80">
                  <template #default="{ row }">
                    <el-tag v-if="row.status === 'FINISHED'" type="success" size="small">已提交</el-tag>
                    <el-tag v-else type="warning" size="small">进行中</el-tag>
                  </template>
                </el-table-column>
                <el-table-column prop="pendingCount" label="待批改" min-width="80">
                  <template #default="{ row }">
                    <el-tag v-if="row.pendingCount > 0" type="warning" size="small">{{ row.pendingCount }}题</el-tag>
                    <span v-else style="color: #67C23A; font-size: 12px;">无</span>
                  </template>
                </el-table-column>
                <el-table-column prop="submitTime" label="提交时间" min-width="170" />
                <el-table-column label="操作" min-width="150" fixed="right">
                  <template #default="{ row }">
                    <el-button size="small" type="primary" @click="openStudentDetail(exam.examId, row)">查看详情</el-button>
                  </template>
                </el-table-column>
              </el-table>
            </div>
          </div>
        </div>
      </el-card>

      <!-- 学生答题详情弹窗 -->
      <el-dialog v-model="detailVisible" :title="detailDialogTitle" width="900px" top="5vh">
        <div style="margin-bottom: 15px; display: flex; gap: 15px; align-items: center;">
          <el-checkbox v-model="showOnlyPending" label="只看待批改" />
          <span v-if="pendingDetailCount > 0" style="color: #E6A23C; font-weight: bold;">{{ pendingDetailCount }}题待批改</span>
        </div>
        <div v-if="detailLoading" style="text-align: center; padding: 30px;">
          <el-icon class="is-loading" :size="30"><Loading /></el-icon>
        </div>
        <div v-else-if="filteredDetail.length === 0" style="text-align: center; padding: 30px; color: #909399;">
          无匹配数据
        </div>
        <div v-else style="max-height: 65vh; overflow-y: auto;">
          <div v-for="(item, index) in filteredDetail" :key="item.scoreId" class="detail-item">
            <!-- 题目头部 -->
            <div class="detail-header">
              <span class="detail-number">第 {{ index + 1 }} 题</span>
              <el-tag size="small">{{ getQuestionTypeName(item.questionType) }}</el-tag>
              <el-tag v-if="item.questionDifficulty" size="small" :type="getDifficultyType(item.questionDifficulty)" style="margin-left: 5px;">
                {{ getDifficultyName(item.questionDifficulty) }}
              </el-tag>
              <el-tag v-if="item.knowledgePoint" size="small" type="warning" style="margin-left: 5px;">{{ item.knowledgePoint }}</el-tag>
              <span style="margin-left: auto; font-size: 13px;">
                得分: <span :style="{ color: item.score > 0 ? '#67C23A' : '#F56C6C', fontWeight: 'bold' }">{{ item.score }}</span> / {{ item.fullScore }}
                <el-tag v-if="item.status === 'CORRECT'" type="success" size="small" style="margin-left: 5px;">正确</el-tag>
                <el-tag v-else-if="item.status === 'WRONG'" type="danger" size="small" style="margin-left: 5px;">错误</el-tag>
                <el-tag v-else-if="item.status === 'PENDING'" type="warning" size="small" style="margin-left: 5px;">待批改</el-tag>
                <el-tag v-else-if="item.status === 'GRADED'" type="info" size="small" style="margin-left: 5px;">已批改</el-tag>
              </span>
            </div>

            <!-- 题目内容 -->
            <div class="detail-content">{{ item.questionContent }}</div>

            <!-- 选择题选项 -->
            <div v-if="item.questionOptions && (item.questionType === 'SINGLE' || item.questionType === 'MULTIPLE')" class="detail-options">
              <div v-for="(option, oi) in parseOptions(item.questionOptions)" :key="oi" class="option-item"
                   :class="{
                     'option-correct': isCorrectOption(option, item.correctAnswer),
                     'option-wrong': isWrongOption(option, item.studentAnswer, item.correctAnswer)
                   }">
                {{ option }}
              </div>
            </div>

            <!-- 判断题选项 -->
            <div v-if="item.questionType === 'JUDGE'" class="detail-options">
              <span class="option-item" :class="{ 'option-correct': item.correctAnswer === '正确', 'option-wrong': item.studentAnswer === '正确' && item.correctAnswer !== '正确' }">正确</span>
              <span class="option-item" :class="{ 'option-correct': item.correctAnswer === '错误', 'option-wrong': item.studentAnswer === '错误' && item.correctAnswer !== '错误' }">错误</span>
            </div>

            <!-- 答案对比 -->
            <div class="answer-compare">
              <div class="answer-row wrong-answer">
                <span class="answer-label">学生答案:</span>
                <span class="answer-value">{{ formatAnswerDisplay(item.studentAnswer, item) }}</span>
              </div>
              <div class="answer-row correct-answer">
                <span class="answer-label">正确答案:</span>
                <span class="answer-value">{{ formatAnswerDisplay(item.correctAnswer, item) }}</span>
              </div>
            </div>

            <!-- 批改区域 -->
            <div v-if="item.status === 'PENDING'" class="grading-area">
              <el-form :inline="true" size="small">
                <el-form-item label="评分">
                  <el-input-number v-model="gradingForm[item.scoreId].score" :min="0" :max="item.fullScore" />
                </el-form-item>
                <el-form-item label="评语">
                  <el-input v-model="gradingForm[item.scoreId].comment" placeholder="请输入评语" style="width: 250px;" />
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" @click="handleGrade(item.scoreId, item)">保存评分</el-button>
                </el-form-item>
              </el-form>
            </div>

            <!-- 已有评语 -->
            <div v-if="item.comment" class="comment-area">评语: {{ item.comment }}</div>

            <!-- 解析 -->
            <div v-if="item.questionAnalysis" class="analysis-area">
              <div class="analysis-title">解析</div>
              <div>{{ item.questionAnalysis }}</div>
            </div>
          </div>
        </div>
      </el-dialog>
    </template>

    <!-- ==================== 学生端 ==================== -->
    <template v-else>
      <el-card>
        <template #header>
          <span>我的成绩</span>
        </template>
        <el-table :data="myScores" border style="width: 100%">
          <el-table-column prop="examTitle" label="考试名称" min-width="200" />
          <el-table-column prop="score" label="分数" min-width="100">
            <template #default="{ row }">
              <span :style="{ color: row.score >= 60 ? '#67C23A' : '#F56C6C', fontWeight: 'bold' }">{{ row.score }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="status" label="状态" min-width="100">
            <template #default="{ row }">
              <el-tag v-if="row.status === 'FINISHED'" type="success">已提交</el-tag>
              <el-tag v-else type="warning">进行中</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="submitTime" label="提交时间" min-width="180" />
        </el-table>
      </el-card>
    </template>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { getExamScoreOverview, getStudentExamDetail, updateSubjectiveScore, getScoresByStudent } from '../api/score'
import { getExamList } from '../api/exam'
import { getCurrentUser } from '../api/user'
import { useUserStore } from '../stores/user'

const userStore = useUserStore()
const isTeacherOrAdmin = computed(() => ['TEACHER', 'ADMIN'].includes(userStore.role))

// ========== 教师/管理员 ==========
const overviewLoading = ref(false)
const examOverviewList = ref([])
const expandedExams = ref({})

const detailVisible = ref(false)
const detailLoading = ref(false)
const detailDialogTitle = ref('')
const currentExamId = ref(null)
const currentStudentId = ref(null)
const currentStudentName = ref('')
const scoreDetail = ref([])
const gradingForm = ref({})
const showOnlyPending = ref(false)

const pendingDetailCount = computed(() => scoreDetail.value.filter(i => i.status === 'PENDING').length)

const filteredDetail = computed(() => {
  if (!showOnlyPending.value) return scoreDetail.value
  return scoreDetail.value.filter(item => item.status === 'PENDING')
})

const loadOverview = async () => {
  overviewLoading.value = true
  try {
    const res = await getExamScoreOverview()
    examOverviewList.value = res.data || []
  } catch (error) {
    ElMessage.error('加载成绩概览失败')
  } finally {
    overviewLoading.value = false
  }
}

const toggleExam = (examId) => {
  expandedExams.value[examId] = !expandedExams.value[examId]
}

const openStudentDetail = async (examId, studentRow) => {
  currentExamId.value = examId
  currentStudentId.value = studentRow.studentId
  currentStudentName.value = studentRow.studentName
  detailDialogTitle.value = `${studentRow.studentName} 的答题详情`
  detailVisible.value = true
  detailLoading.value = true

  try {
    const res = await getStudentExamDetail(examId, studentRow.studentId)
    scoreDetail.value = res.data || []
    gradingForm.value = {}
    scoreDetail.value.forEach(item => {
      gradingForm.value[item.scoreId] = {
        score: item.score || 0,
        comment: item.comment || ''
      }
    })
  } catch (error) {
    ElMessage.error('加载答题详情失败')
  } finally {
    detailLoading.value = false
  }
}

const handleGrade = async (scoreId, item) => {
  try {
    const form = gradingForm.value[scoreId]
    await updateSubjectiveScore(scoreId, {
      score: form.score,
      comment: form.comment
    })
    item.score = form.score
    item.comment = form.comment
    item.status = form.score > 0 ? 'GRADED' : 'WRONG'
    ElMessage.success('评分成功')
    loadOverview()
  } catch (error) {
    ElMessage.error(error.response?.data?.message || '评分失败')
  }
}

// ========== 学生端 ==========
const myScores = ref([])

const loadMyScores = async () => {
  try {
    const userRes = await getCurrentUser()
    const userId = userRes.data.id
    const examsRes = await getExamList({ page: 1, size: 1000 })
    const exams = examsRes.data.records || []
    const scores = []
    for (const exam of exams) {
      try {
        const scoreRes = await getScoresByStudent(exam.id, userId)
        if (scoreRes.data && scoreRes.data.length > 0) {
          scores.push({
            examId: exam.id,
            examTitle: exam.title,
            score: scoreRes.data.reduce((sum, s) => sum + (s.score || 0), 0),
            status: 'FINISHED',
            submitTime: scoreRes.data[0].createTime
          })
        }
      } catch (error) {
        console.error(error)
      }
    }
    myScores.value = scores
  } catch (error) {
    ElMessage.error('加载成绩失败')
  }
}

// ========== 通用工具 ==========
const getExamStatusName = (status) => {
  const map = { NOT_STARTED: '未开始', IN_PROGRESS: '进行中', FINISHED: '已结束' }
  return map[status] || status
}

const getQuestionTypeName = (type) => {
  const map = { SINGLE: '单选题', MULTIPLE: '多选题', JUDGE: '判断题', FILL: '填空题', ESSAY: '简答题' }
  return map[type] || type
}

const getDifficultyType = (d) => ({ EASY: 'success', MEDIUM: 'warning', HARD: 'danger' }[d] || '')
const getDifficultyName = (d) => ({ EASY: '简单', MEDIUM: '中等', HARD: '困难' }[d] || d)

const parseOptions = (options) => {
  if (!options) return []
  return options.split('\n').filter(s => s.trim())
}

const getOptionLetter = (option) => {
  if (!option) return ''
  const match = option.trim().match(/^([A-Za-z])[.、．\s]/)
  return match ? match[1].toUpperCase() : option.trim()
}

const isCorrectOption = (option, correctAnswer) => {
  if (!correctAnswer) return false
  const letter = getOptionLetter(option)
  return correctAnswer.split(',').map(s => s.trim().toUpperCase()).includes(letter)
}

const isWrongOption = (option, studentAnswer, correctAnswer) => {
  if (!studentAnswer) return false
  const letter = getOptionLetter(option)
  const studentLetters = studentAnswer.split(',').map(s => s.trim().toUpperCase())
  const correctLetters = correctAnswer ? correctAnswer.split(',').map(s => s.trim().toUpperCase()) : []
  return studentLetters.includes(letter) && !correctLetters.includes(letter)
}

const formatAnswerDisplay = (answer, item) => {
  if (!answer) return '未作答'
  if (item.questionType === 'FILL' || item.questionType === 'ESSAY' || item.questionType === 'JUDGE') return answer
  const options = parseOptions(item.questionOptions)
  if (!options || options.length === 0) return answer
  const letterMap = {}
  options.forEach(opt => {
    const match = opt.trim().match(/^([A-Za-z])[.、．\s]/)
    if (match) letterMap[match[1].toUpperCase()] = opt.trim()
  })
  if (answer.includes(',')) {
    return answer.split(',').map(l => letterMap[l.trim().toUpperCase()] || l).join('；')
  }
  return letterMap[answer.trim().toUpperCase()] || answer
}

onMounted(() => {
  if (isTeacherOrAdmin.value) {
    loadOverview()
  } else {
    loadMyScores()
  }
})
</script>

<style scoped>
.exam-card {
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  margin-bottom: 15px;
  overflow: hidden;
}

.exam-header {
  display: flex;
  align-items: center;
  padding: 18px 20px;
  cursor: pointer;
  background: #fafafa;
  transition: background 0.2s;
}

.exam-header:hover {
  background: #f0f2f5;
}

.exam-info {
  flex: 1;
}

.exam-info h3 {
  font-size: 16px;
  color: #303133;
}

.exam-meta {
  display: flex;
  gap: 12px;
  margin-top: 8px;
  font-size: 13px;
  color: #909399;
  align-items: center;
}

.exam-stats {
  display: flex;
  gap: 25px;
}

.stat-item {
  text-align: center;
}

.stat-value {
  font-size: 22px;
  font-weight: bold;
  color: #303133;
}

.stat-label {
  font-size: 12px;
  color: #909399;
  margin-top: 2px;
}

.student-table-wrap {
  padding: 15px 20px;
  border-top: 1px solid #e4e7ed;
}

/* 详情弹窗样式 */
.detail-item {
  margin-bottom: 20px;
  padding: 18px;
  border: 1px solid #e4e7ed;
  border-radius: 6px;
}

.detail-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 12px;
}

.detail-number {
  font-weight: bold;
  font-size: 15px;
  color: #303133;
}

.detail-content {
  font-size: 14px;
  line-height: 1.8;
  margin-bottom: 12px;
  color: #303133;
}

.detail-options {
  margin-bottom: 12px;
}

.option-item {
  padding: 8px 12px;
  margin-bottom: 6px;
  border: 1px solid #e4e7ed;
  border-radius: 4px;
  background: #fafafa;
  line-height: 1.5;
}

.option-correct {
  background: #f0f9eb;
  border-color: #67c23a;
  color: #67c23a;
  font-weight: bold;
}

.option-wrong {
  background: #fef0f0;
  border-color: #f56c6c;
  color: #f56c6c;
  text-decoration: line-through;
}

.answer-compare {
  display: flex;
  gap: 25px;
  padding: 12px;
  background: #f5f7fa;
  border-radius: 4px;
  margin-bottom: 12px;
  flex-wrap: wrap;
}

.answer-row {
  display: flex;
  align-items: center;
  gap: 6px;
}

.answer-label {
  font-weight: bold;
  font-size: 13px;
}

.wrong-answer .answer-label { color: #f56c6c; }
.wrong-answer .answer-value { color: #f56c6c; text-decoration: line-through; }
.correct-answer .answer-label { color: #67c23a; }
.correct-answer .answer-value { color: #67c23a; font-weight: bold; }

.grading-area {
  margin-top: 10px;
  padding: 12px;
  background: #fdf6ec;
  border-radius: 4px;
  border: 1px solid #e6a23c;
}

.comment-area {
  margin-top: 8px;
  padding: 8px 12px;
  color: #606266;
  font-size: 13px;
  background: #f5f7fa;
  border-radius: 4px;
}

.analysis-area {
  margin-top: 10px;
  padding: 12px;
  background: #ecf5ff;
  border-radius: 4px;
  border-left: 3px solid #409EFF;
}

.analysis-area .analysis-title {
  font-weight: bold;
  color: #409EFF;
  margin-bottom: 6px;
  font-size: 13px;
}
</style>
