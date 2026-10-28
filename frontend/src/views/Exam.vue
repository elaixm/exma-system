<template>
  <div class="exam-container">
    <el-card>
      <template #header>
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <h2>{{ examInfo.title }}</h2>
          <div>
            <el-tag type="warning" size="large">剩余时间: {{ formatTime(remainingTime) }}</el-tag>
            <el-button type="primary" @click="handleSubmit" style="margin-left: 20px;">提交试卷</el-button>
          </div>
        </div>
      </template>
      <div v-loading="questions.length === 0" style="min-height: 400px;">
        <div v-for="(question, index) in questions" :key="question.id" class="question-item">
          <div class="question-header">
            <span class="question-number">第 {{ index + 1 }} 题</span>
            <el-tag>{{ getQuestionTypeName(question.type) }}</el-tag>
            <span class="question-score">分值: {{ question.score }} 分</span>
          </div>
          <div class="question-content">{{ question.content }}</div>
          <div v-if="question.options" class="question-options">
            <div v-if="question.type === 'SINGLE'">
              <div v-for="(option, optIndex) in parseOptions(question.options)" :key="optIndex" class="option-item">
                <el-radio
                  v-model="answers[question.id]"
                  :label="getOptionLetter(option)"
                >{{ option }}</el-radio>
              </div>
            </div>
            <el-checkbox-group v-else-if="question.type === 'MULTIPLE'" v-model="answers[question.id]">
              <div v-for="(option, optIndex) in parseOptions(question.options)" :key="optIndex" class="option-item">
                <el-checkbox :label="getOptionLetter(option)">{{ option }}</el-checkbox>
              </div>
            </el-checkbox-group>
          </div>
          <div v-if="question.type === 'JUDGE'" class="question-options">
            <el-radio-group v-model="answers[question.id]">
              <el-radio label="正确">正确</el-radio>
              <el-radio label="错误">错误</el-radio>
            </el-radio-group>
          </div>
          <div v-if="question.type === 'FILL' || question.type === 'ESSAY'">
            <el-input
              v-model="answers[question.id]"
              type="textarea"
              :rows="question.type === 'ESSAY' ? 6 : 3"
              placeholder="请输入答案"
            />
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getExamById, getExamQuestions, saveAnswer, submitExam } from '../api/exam'
import { logAction } from '../api/examLog'

const route = useRoute()
const router = useRouter()

const examId = ref(route.params.id)
const examInfo = ref({})
const questions = ref([])
const answers = ref({})
const remainingTime = ref(0)
let timer = null

// 监听答案变化，记录答案修改日志
let lastAnswerChangeTime = 0
const ANSWER_CHANGE_THROTTLE = 5000 // 5秒内只记录一次

watch(answers, (newAnswers, oldAnswers) => {
  // 节流：避免频繁记录
  const now = Date.now()
  if (now - lastAnswerChangeTime < ANSWER_CHANGE_THROTTLE) {
    return
  }
  
  // 检查是否有实际变化
  let hasChange = false
  for (const key in newAnswers) {
    if (JSON.stringify(newAnswers[key]) !== JSON.stringify(oldAnswers?.[key])) {
      hasChange = true
      break
    }
  }
  
  if (hasChange && Object.keys(oldAnswers || {}).length > 0) {
    lastAnswerChangeTime = now
    logAction(examId.value, 'ANSWER_CHANGE', '答案被修改').catch(err => {
      console.error('记录答案修改日志失败', err)
    })
  }
}, { deep: true })

onMounted(async () => {
  await loadExamInfo()
  await loadQuestions()
  startTimer()
  setupVisibilityCheck()
  setupCameraCapture()
})

onUnmounted(() => {
  if (timer) {
    clearInterval(timer)
  }
})

const loadExamInfo = async () => {
  try {
    const res = await getExamById(examId.value)
    examInfo.value = res.data
    
    // 校验考试状态
    if (res.data.status === 'FINISHED') {
      ElMessage.error('考试已结束')
      router.push('/exams')
      return
    }
    if (res.data.status === 'NOT_STARTED') {
      ElMessage.error('考试尚未开始')
      router.push('/exams')
      return
    }
    
    // 校验考试时间
    const now = new Date()
    const startTime = new Date(res.data.startTime)
    const endTime = new Date(res.data.endTime)
    if (now < startTime) {
      ElMessage.error('考试未到开始时间')
      router.push('/exams')
      return
    }
    if (now > endTime) {
      ElMessage.error('考试已过结束时间')
      router.push('/exams')
      return
    }
    
    // 计算剩余时间（取考试时长和结束时间的较小值）
    const durationSeconds = res.data.duration * 60
    const endTimeSeconds = Math.floor((endTime.getTime() - now.getTime()) / 1000)
    remainingTime.value = Math.min(durationSeconds, endTimeSeconds)
  } catch (error) {
    ElMessage.error('加载考试信息失败')
    router.push('/exams')
  }
}

const loadQuestions = async () => {
  try {
    const res = await getExamQuestions(examId.value)
    questions.value = res.data
    // 初始化答案
    questions.value.forEach(question => {
      if (question.type === 'MULTIPLE') {
        // 多选题初始化为空数组（存储选项字母如 ['A', 'C']）
        if (!answers.value[question.id] || !Array.isArray(answers.value[question.id])) {
          answers.value[question.id] = []
        }
      } else {
        // 单选/判断/填空/简答 初始化为空字符串
        if (answers.value[question.id] === undefined) {
          answers.value[question.id] = ''
        }
      }
    })
  } catch (error) {
    ElMessage.error('加载题目失败')
  }
}

const startTimer = () => {
  timer = setInterval(() => {
    remainingTime.value--
    if (remainingTime.value <= 0) {
      clearInterval(timer)
      handleAutoSubmit()
    }
    if (remainingTime.value % 30 === 0) {
      saveAnswers()
    }
  }, 1000)
}

const formatTime = (seconds) => {
  const h = Math.floor(seconds / 3600)
  const m = Math.floor((seconds % 3600) / 60)
  const s = seconds % 60
  return `${String(h).padStart(2, '0')}:${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`
}

const getQuestionTypeName = (type) => {
  const map = {
    SINGLE: '单选题',
    MULTIPLE: '多选题',
    JUDGE: '判断题',
    FILL: '填空题',
    ESSAY: '简答题'
  }
  return map[type] || type
}

const parseOptions = (options) => {
  if (!options) return []
  return options.split('\n').filter(s => s.trim())
}

// 从选项文本中提取选项字母（如从"A.一心一意"中提取"A"）
const getOptionLetter = (option) => {
  if (!option) return ''
  const match = option.trim().match(/^([A-Za-z])[.、．\s]/)
  return match ? match[1].toUpperCase() : option.trim()
}

const saveAnswers = async () => {
  try {
    const answerStr = Object.entries(answers.value)
      .map(([id, answer]) => {
        if (Array.isArray(answer)) {
          return `${id}:${answer.join(',')}`
        }
        return `${id}:${answer || ''}`
      })
      .join(';')
    await saveAnswer(examId.value, answerStr)
  } catch (error) {
    console.error('保存答案失败', error)
  }
}

const setupVisibilityCheck = () => {
  document.addEventListener('visibilitychange', () => {
    if (document.hidden) {
      ElMessage.warning('检测到窗口切换，请保持考试页面在前台')
      // 记录页面切换日志
      logAction(examId.value, 'PAGE_VISIBILITY_CHANGE', '页面切换到后台').catch(err => {
        console.error('记录页面切换日志失败', err)
      })
    } else {
      // 记录页面恢复日志
      logAction(examId.value, 'PAGE_VISIBILITY_CHANGE', '页面恢复到前台').catch(err => {
        console.error('记录页面恢复日志失败', err)
      })
    }
  })
}

const setupCameraCapture = () => {
  if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
    navigator.mediaDevices.getUserMedia({ video: true })
      .then(stream => {
        const video = document.createElement('video')
        video.srcObject = stream
        video.play()
        
        setInterval(() => {
          const canvas = document.createElement('canvas')
          canvas.width = video.videoWidth
          canvas.height = video.videoHeight
          const ctx = canvas.getContext('2d')
          ctx.drawImage(video, 0, 0)
          const imageData = canvas.toDataURL('image/jpeg', 0.8)
          console.log('Camera capture:', imageData.substring(0, 50) + '...')
        }, 30000)
      })
      .catch(error => {
        console.log('Camera access denied or not available')
      })
  }
}

const handleSubmit = async () => {
  try {
    await ElMessageBox.confirm('确定要提交试卷吗？提交后无法修改。', '提示', {
      type: 'warning'
    })
    const answerStr = Object.entries(answers.value)
      .map(([id, answer]) => {
        if (Array.isArray(answer)) {
          return `${id}:${answer.join(',')}`
        }
        return `${id}:${answer || ''}`
      })
      .join(';')
    await submitExam(examId.value, answerStr)
    ElMessage.success('提交成功')
    router.push('/scores')
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error(error.message || '提交失败')
    }
  }
}

const handleAutoSubmit = async () => {
  try {
    const answerStr = Object.entries(answers.value)
      .map(([id, answer]) => {
        if (Array.isArray(answer)) {
          return `${id}:${answer.join(',')}`
        }
        return `${id}:${answer || ''}`
      })
      .join(';')
    await submitExam(examId.value, answerStr)
    ElMessage.warning('考试时间到，已自动提交')
    router.push('/scores')
  } catch (error) {
    ElMessage.error('自动提交失败')
  }
}
</script>

<style scoped>
.exam-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.question-item {
  margin-bottom: 30px;
  padding: 20px;
  border: 1px solid #e4e7ed;
  border-radius: 4px;
}

.question-header {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 15px;
}

.question-number {
  font-weight: bold;
  font-size: 16px;
}

.question-score {
  margin-left: auto;
  color: #409EFF;
}

.question-content {
  font-size: 15px;
  line-height: 1.6;
  margin-bottom: 15px;
}

.question-options {
  margin-top: 15px;
}

.option-item {
  margin-bottom: 10px;
}
</style>

