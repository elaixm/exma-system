<template>
  <div>
    <!-- 筛选区域 -->
    <el-card style="margin-bottom: 20px;">
      <el-form :inline="true">
        <el-form-item label="知识点">
          <el-select v-model="filterKnowledgePoint" clearable placeholder="全部知识点" style="width: 250px;">
            <el-option
              v-for="(count, kp) in knowledgePointCount"
              :key="kp"
              :label="`${kp} (${count}题)`"
              :value="kp"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="题目类型">
          <el-select v-model="filterType" clearable placeholder="全部类型" style="width: 150px;">
            <el-option label="单选题" value="SINGLE" />
            <el-option label="多选题" value="MULTIPLE" />
            <el-option label="判断题" value="JUDGE" />
            <el-option label="填空题" value="FILL" />
            <el-option label="简答题" value="ESSAY" />
          </el-select>
        </el-form-item>
        <el-form-item label="难度">
          <el-select v-model="filterDifficulty" clearable placeholder="全部难度" style="width: 120px;">
            <el-option label="简单" value="EASY" />
            <el-option label="中等" value="MEDIUM" />
            <el-option label="困难" value="HARD" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleFilter">筛选</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 统计概览 -->
    <el-card style="margin-bottom: 20px;">
      <div style="display: flex; gap: 40px; align-items: center; flex-wrap: wrap;">
        <div style="text-align: center;">
          <div style="font-size: 32px; font-weight: bold; color: #F56C6C;">{{ totalWrong }}</div>
          <div style="color: #909399; margin-top: 4px;">错题总数</div>
        </div>
        <div style="text-align: center;">
          <div style="font-size: 32px; font-weight: bold; color: #E6A23C;">{{ Object.keys(knowledgePointCount).length }}</div>
          <div style="color: #909399; margin-top: 4px;">薄弱知识点</div>
        </div>
        <div style="text-align: center;">
          <div style="font-size: 32px; font-weight: bold; color: #409EFF;">{{ filteredList.length }}</div>
          <div style="color: #909399; margin-top: 4px;">当前筛选</div>
        </div>
        <!-- 各知识点错题数分布 -->
        <div style="flex: 1; min-width: 300px;">
          <div v-for="(count, kp) in knowledgePointCount" :key="kp" style="display: flex; align-items: center; gap: 10px; margin-bottom: 6px;">
            <span style="width: 100px; text-align: right; font-size: 13px; color: #606266; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" :title="kp">{{ kp }}</span>
            <el-progress :percentage="Math.round(count / totalWrong * 100)" :stroke-width="16" :format="() => count + '题'" style="flex: 1;" />
          </div>
        </div>
      </div>
    </el-card>

    <!-- 错题列表 - 按知识点分组展示 -->
    <el-card v-loading="loading">
      <template #header>
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <span>错题本</span>
          <el-switch v-model="groupByKnowledge" active-text="按知识点分组" inactive-text="列表模式" />
        </div>
      </template>

      <!-- 无数据 -->
      <div v-if="!loading && filteredList.length === 0" style="text-align: center; padding: 50px; color: #909399;">
        <el-icon style="font-size: 60px; margin-bottom: 15px;"><CircleCheck /></el-icon>
        <div>暂无错题，继续保持！</div>
      </div>

      <!-- 分组模式 -->
      <div v-if="groupByKnowledge && filteredList.length > 0">
        <div v-for="(items, kp) in groupedByKnowledgePoint" :key="kp" style="margin-bottom: 30px;">
          <div class="group-header">
            <el-tag type="warning" size="large">{{ kp }}</el-tag>
            <span class="group-count">共 {{ items.length }} 道错题</span>
            <!-- 该知识点下的题型分布 -->
            <span class="group-type-info">
              <el-tag v-for="(typeCount, type) in getGroupTypeCount(items)" :key="type" size="small" style="margin-left: 5px;">
                {{ getQuestionTypeName(type) }} {{ typeCount }}
              </el-tag>
            </span>
          </div>
          <div v-for="(item, index) in items" :key="item.scoreId" class="wrong-item">
            <wrong-question-detail :item="item" :index="getItemGlobalIndex(item)" />
          </div>
        </div>
      </div>

      <!-- 列表模式 -->
      <div v-if="!groupByKnowledge && filteredList.length > 0">
        <div v-for="(item, index) in filteredList" :key="item.scoreId" class="wrong-item">
          <wrong-question-detail :item="item" :index="index" />
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, h } from 'vue'
import { ElMessage, ElTag, ElIcon } from 'element-plus'
import { getWrongBook } from '../api/score'

const loading = ref(true)
const wrongList = ref([])
const knowledgePointCount = ref({})
const knowledgePointTypeCount = ref({})
const totalWrong = ref(0)
const filterKnowledgePoint = ref('')
const filterType = ref('')
const filterDifficulty = ref('')
const groupByKnowledge = ref(true)

// 筛选后的错题列表
const filteredList = computed(() => {
  let list = wrongList.value
  if (filterType.value) {
    list = list.filter(item => item.questionType === filterType.value)
  }
  if (filterDifficulty.value) {
    list = list.filter(item => item.questionDifficulty === filterDifficulty.value)
  }
  return list
})

// 按知识点分组
const groupedByKnowledgePoint = computed(() => {
  const groups = {}
  filteredList.value.forEach(item => {
    const kp = item.knowledgePoint || '未分类'
    if (!groups[kp]) groups[kp] = []
    groups[kp].push(item)
  })
  return groups
})

const loadData = async () => {
  loading.value = true
  try {
    const params = {}
    if (filterKnowledgePoint.value) {
      params.knowledgePoint = filterKnowledgePoint.value
    }
    const res = await getWrongBook(params)
    const data = res.data || {}
    wrongList.value = data.wrongList || []
    knowledgePointCount.value = data.knowledgePointCount || {}
    knowledgePointTypeCount.value = data.knowledgePointTypeCount || {}
    totalWrong.value = data.totalWrong || 0
  } catch (error) {
    ElMessage.error('加载错题本失败')
  } finally {
    loading.value = false
  }
}

const handleFilter = () => {
  loadData()
}

const handleReset = () => {
  filterKnowledgePoint.value = ''
  filterType.value = ''
  filterDifficulty.value = ''
  loadData()
}

const getQuestionTypeName = (type) => {
  const map = { SINGLE: '单选', MULTIPLE: '多选', JUDGE: '判断', FILL: '填空', ESSAY: '简答' }
  return map[type] || type
}

// 获取分组内题型统计
const getGroupTypeCount = (items) => {
  const counts = {}
  items.forEach(item => {
    counts[item.questionType] = (counts[item.questionType] || 0) + 1
  })
  return counts
}

// 获取错题在全局列表中的序号
const getItemGlobalIndex = (item) => {
  return filteredList.value.findIndex(i => i.scoreId === item.scoreId)
}

// ===================== 错题详情子组件 =====================
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
  // 填空题和简答题直接显示文本
  if (item.questionType === 'FILL' || item.questionType === 'ESSAY') return answer
  // 判断题直接显示
  if (item.questionType === 'JUDGE') return answer
  // 选择题将字母还原为选项文本
  const options = parseOptions(item.questionOptions)
  if (!options || options.length === 0) return answer
  const letterMap = {}
  options.forEach(opt => {
    const match = opt.trim().match(/^([A-Za-z])[.、．\s]/)
    if (match) {
      letterMap[match[1].toUpperCase()] = opt.trim()
    }
  })
  if (answer.includes(',')) {
    return answer.split(',').map(letter => {
      const upper = letter.trim().toUpperCase()
      return letterMap[upper] || letter
    }).join('；')
  }
  const upper = answer.trim().toUpperCase()
  return letterMap[upper] || answer
}

const getDifficultyType = (difficulty) => {
  const map = { EASY: 'success', MEDIUM: 'warning', HARD: 'danger' }
  return map[difficulty] || ''
}

const getDifficultyName = (difficulty) => {
  const map = { EASY: '简单', MEDIUM: '中等', HARD: '困难' }
  return map[difficulty] || difficulty
}

// 使用函数式组件渲染单个错题详情
const wrongQuestionDetail = {
  props: ['item', 'index'],
  setup(props) {
    return () => {
      const item = props.item
      const index = props.index
      const typeMap = { SINGLE: '单选题', MULTIPLE: '多选题', JUDGE: '判断题', FILL: '填空题', ESSAY: '简答题' }
      const diffTypeMap = { EASY: 'success', MEDIUM: 'warning', HARD: 'danger' }
      const diffNameMap = { EASY: '简单', MEDIUM: '中等', HARD: '困难' }

      // 判断题选项
      const isJudge = item.questionType === 'JUDGE'
      // 选择题选项
      const hasOptions = item.questionOptions && !isJudge
      const options = parseOptions(item.questionOptions)

      return h('div', {}, [
        // 标题行
        h('div', { class: 'wrong-header' }, [
          h('span', { class: 'wrong-number' }, `第 ${index + 1} 题`),
          h(ElTag, {}, () => typeMap[item.questionType] || item.questionType),
          item.questionDifficulty
            ? h(ElTag, { type: diffTypeMap[item.questionDifficulty] || '', style: 'margin-left: 5px;' }, () => diffNameMap[item.questionDifficulty] || item.questionDifficulty)
            : null,
          h(ElTag, { type: 'warning', style: 'margin-left: 5px;' }, () => item.knowledgePoint),
          h('span', { class: 'wrong-score' }, `分值: ${item.fullScore} 分`)
        ]),

        // 题目内容
        h('div', { class: 'wrong-content' }, item.questionContent),

        // 选择题选项（仅单选/多选）
        hasOptions ? h('div', { class: 'wrong-options' },
          options.map((option, optIndex) =>
            h('div', {
              key: optIndex,
              class: [
                'option-item',
                isCorrectOption(option, item.correctAnswer) ? 'option-correct' : '',
                isWrongOption(option, item.studentAnswer, item.correctAnswer) ? 'option-wrong' : ''
              ]
            }, option)
          )
        ) : null,

        // 判断题选项
        isJudge ? h('div', { class: 'wrong-options' }, [
          h('span', {
            class: ['option-item', item.correctAnswer === '正确' ? 'option-correct' : '', item.studentAnswer === '正确' && item.correctAnswer !== '正确' ? 'option-wrong' : '']
          }, '正确'),
          h('span', {
            class: ['option-item', item.correctAnswer === '错误' ? 'option-correct' : '', item.studentAnswer === '错误' && item.correctAnswer !== '错误' ? 'option-wrong' : '']
          }, '错误')
        ]) : null,

        // 答案对比
        h('div', { class: 'answer-compare' }, [
          h('div', { class: 'answer-row wrong-answer' }, [
            h('span', { class: 'answer-label' }, '我的答案:'),
            h('span', { class: 'answer-value' }, formatAnswerDisplay(item.studentAnswer, item))
          ]),
          h('div', { class: 'answer-row correct-answer' }, [
            h('span', { class: 'answer-label' }, '正确答案:'),
            h('span', { class: 'answer-value' }, formatAnswerDisplay(item.correctAnswer, item))
          ])
        ]),

        // 解析
        item.questionAnalysis ? h('div', { class: 'analysis-section' }, [
          h('div', { class: 'analysis-title' }, '解析'),
          h('div', { class: 'analysis-content' }, item.questionAnalysis)
        ]) : null,

        // 做错时间
        h('div', { class: 'wrong-time' }, `做错时间: ${item.wrongTime}`)
      ])
    }
  }
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.group-header {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  background: #fdf6ec;
  border-radius: 8px;
  margin-bottom: 15px;
}

.group-count {
  color: #E6A23C;
  font-weight: bold;
  font-size: 14px;
}

.group-type-info {
  margin-left: auto;
}

.wrong-item {
  margin-bottom: 20px;
  padding: 20px;
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  transition: box-shadow 0.3s;
}

.wrong-item:hover {
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.wrong-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 15px;
}

.wrong-number {
  font-weight: bold;
  font-size: 16px;
  color: #303133;
}

.wrong-score {
  margin-left: auto;
  color: #409EFF;
  font-size: 14px;
}

.wrong-content {
  font-size: 15px;
  line-height: 1.8;
  margin-bottom: 15px;
  color: #303133;
}

.wrong-options {
  margin-top: 10px;
  margin-bottom: 15px;
}

.option-item {
  padding: 10px 15px;
  margin-bottom: 8px;
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
  gap: 30px;
  padding: 15px;
  background: #f5f7fa;
  border-radius: 4px;
  margin-bottom: 15px;
  flex-wrap: wrap;
}

.answer-row {
  display: flex;
  align-items: center;
  gap: 8px;
}

.answer-label {
  font-weight: bold;
  font-size: 14px;
}

.wrong-answer .answer-label {
  color: #f56c6c;
}

.wrong-answer .answer-value {
  color: #f56c6c;
  text-decoration: line-through;
}

.correct-answer .answer-label {
  color: #67c23a;
}

.correct-answer .answer-value {
  color: #67c23a;
  font-weight: bold;
}

.analysis-section {
  margin-top: 15px;
  padding: 15px;
  background: #ecf5ff;
  border-radius: 4px;
  border-left: 4px solid #409EFF;
}

.analysis-title {
  font-weight: bold;
  color: #409EFF;
  margin-bottom: 8px;
  font-size: 14px;
}

.analysis-content {
  color: #606266;
  line-height: 1.8;
  font-size: 14px;
}

.wrong-time {
  margin-top: 12px;
  font-size: 12px;
  color: #c0c4cc;
  text-align: right;
}
</style>
