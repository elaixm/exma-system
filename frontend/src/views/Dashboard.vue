<template>
  <div>
    <h2>{{ isStudent ? '个人中心' : '系统概览' }}</h2>
    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="6" v-if="!isStudent">
        <el-card>
          <div class="stat-item">
            <div class="stat-value">{{ stats.totalUsers }}</div>
            <div class="stat-label">总用户数</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6" v-if="!isStudent">
        <el-card>
          <div class="stat-item">
            <div class="stat-value">{{ stats.totalQuestions }}</div>
            <div class="stat-label">总题目数</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card>
          <div class="stat-item">
            <div class="stat-value">{{ isStudent ? stats.totalExams : stats.totalExams }}</div>
            <div class="stat-label">{{ isStudent ? '参加考试数' : '总考试数' }}</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6" v-if="!isStudent">
        <el-card>
          <div class="stat-item">
            <div class="stat-value">{{ stats.totalPapers }}</div>
            <div class="stat-label">总试卷数</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6" v-if="isStudent">
        <el-card>
          <div class="stat-item">
            <div class="stat-value">{{ stats.examCount || 0 }}</div>
            <div class="stat-label">已完成考试</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6" v-if="isStudent">
        <el-card>
          <div class="stat-item">
            <div class="stat-value">{{ stats.wrongQuestionCount || 0 }}</div>
            <div class="stat-label">错题数量</div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 系统全局统计图表（仅教师和管理员可见） -->
    <template v-if="!isStudent">
      <el-row :gutter="20" style="margin-top: 20px;">
        <el-col :span="12">
          <el-card>
            <template #header>
              <span>用户角色分布</span>
            </template>
            <div ref="userRoleChartRef" style="width: 100%; height: 300px;"></div>
          </el-card>
        </el-col>
        <el-col :span="12">
          <el-card>
            <template #header>
              <span>题目类型分布</span>
            </template>
            <div ref="questionTypeChartRef" style="width: 100%; height: 300px;"></div>
          </el-card>
        </el-col>
      </el-row>

      <el-row :gutter="20" style="margin-top: 20px;">
        <el-col :span="12">
          <el-card>
            <template #header>
              <span>题目难度分布</span>
            </template>
            <div ref="questionDifficultyChartRef" style="width: 100%; height: 300px;"></div>
          </el-card>
        </el-col>
        <el-col :span="12">
          <el-card>
            <template #header>
              <span>考试状态分布</span>
            </template>
            <div ref="examStatusChartRef" style="width: 100%; height: 300px;"></div>
          </el-card>
        </el-col>
      </el-row>
    </template>

    <!-- 学生个人统计图表 -->
    <template v-if="isStudent">
      <el-row :gutter="20" style="margin-top: 20px;">
        <el-col :span="12">
          <el-card>
            <template #header>
              <span>薄弱知识点分析</span>
            </template>
            <div ref="knowledgePointChartRef" style="width: 100%; height: 300px;"></div>
          </el-card>
        </el-col>
        <el-col :span="12">
          <el-card>
            <template #header>
              <span>考试状态分布</span>
            </template>
            <div ref="examStatusChartRef" style="width: 100%; height: 300px;"></div>
          </el-card>
        </el-col>
      </el-row>
    </template>

    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="24">
        <el-card>
          <template #header>
            <span>成绩统计</span>
          </template>
          <div style="display: flex; justify-content: space-around; margin-bottom: 20px;">
            <div class="score-stat">
              <div class="score-label">平均分</div>
              <div class="score-value">{{ stats.avgScore.toFixed(2) }}</div>
            </div>
            <div class="score-stat">
              <div class="score-label">最高分</div>
              <div class="score-value">{{ stats.maxScore }}</div>
            </div>
            <div class="score-stat">
              <div class="score-label">最低分</div>
              <div class="score-value">{{ stats.minScore }}</div>
            </div>
            <div class="score-stat">
              <div class="score-label">{{ isStudent ? '已完成考试' : '已完成考试' }}</div>
              <div class="score-value">{{ stats.finishedExamRecords }} / {{ stats.totalExamRecords }}</div>
            </div>
            <div class="score-stat" v-if="isStudent">
              <div class="score-label">总分</div>
              <div class="score-value">{{ stats.totalScore }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick, computed } from 'vue'
import * as echarts from 'echarts'
import { getStatistics } from '../api/dashboard'
import { ElMessage } from 'element-plus'
import { useUserStore } from '../stores/user'

const userStore = useUserStore()
const isStudent = computed(() => userStore.role === 'STUDENT')

const stats = ref({
  totalUsers: 0,
  totalQuestions: 0,
  totalExams: 0,
  totalPapers: 0,
  userStats: {},
  questionTypeStats: {},
  questionDifficultyStats: {},
  examStatusStats: {},
  totalExamRecords: 0,
  finishedExamRecords: 0,
  inProgressRecords: 0,
  avgScore: 0,
  maxScore: 0,
  minScore: 0,
  totalScore: 0,
  examCount: 0,
  knowledgePointErrors: {},
  wrongQuestionCount: 0,
  totalQuestionCount: 0
})

const userRoleChartRef = ref(null)
const questionTypeChartRef = ref(null)
const questionDifficultyChartRef = ref(null)
const examStatusChartRef = ref(null)
const knowledgePointChartRef = ref(null)

let userRoleChart = null
let questionTypeChart = null
let questionDifficultyChart = null
let examStatusChart = null
let knowledgePointChart = null

const initCharts = () => {
  nextTick(() => {
    // 学生个人图表
    if (isStudent.value) {
      // 薄弱知识点分析图表
      if (knowledgePointChartRef.value) {
        knowledgePointChart = echarts.init(knowledgePointChartRef.value)
        const knowledgePointData = Object.entries(stats.value.knowledgePointErrors || {}).map(([name, value]) => ({
          name,
          value
        }))
        
        if (knowledgePointData.length > 0) {
          knowledgePointChart.setOption({
            tooltip: {
              trigger: 'item',
              formatter: '{a} <br/>{b}: {c}题 ({d}%)'
            },
            legend: {
              orient: 'vertical',
              left: 'left'
            },
            series: [
              {
                name: '错题数',
                type: 'pie',
                radius: '50%',
                data: knowledgePointData,
                emphasis: {
                  itemStyle: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                  }
                }
              }
            ]
          })
        } else {
          knowledgePointChart.setOption({
            title: {
              text: '暂无错题数据',
              left: 'center',
              top: 'center',
              textStyle: {
                color: '#909399',
                fontSize: 16
              }
            }
          })
        }
      }
      
      // 考试状态分布图表（学生）
      if (examStatusChartRef.value) {
        examStatusChart = echarts.init(examStatusChartRef.value)
        const examStatusData = [
          { value: stats.value.examStatusStats?.NOT_STARTED || 0, name: '未开始' },
          { value: stats.value.inProgressRecords || 0, name: '进行中' },
          { value: stats.value.finishedExamRecords || 0, name: '已完成' }
        ]
        examStatusChart.setOption({
          tooltip: {
            trigger: 'item',
            formatter: '{a} <br/>{b}: {c} ({d}%)'
          },
          legend: {
            orient: 'vertical',
            left: 'left'
          },
          series: [
            {
              name: '考试状态',
              type: 'pie',
              radius: '50%',
              data: examStatusData,
              emphasis: {
                itemStyle: {
                  shadowBlur: 10,
                  shadowOffsetX: 0,
                  shadowColor: 'rgba(0, 0, 0, 0.5)'
                }
              }
            }
          ]
        })
      }
    } else {
      // 系统全局图表（教师和管理员）
      // 用户角色分布图表
      if (userRoleChartRef.value) {
        userRoleChart = echarts.init(userRoleChartRef.value)
      const userRoleData = [
        { value: stats.value.userStats.ADMIN || 0, name: '管理员' },
        { value: stats.value.userStats.TEACHER || 0, name: '教师' },
        { value: stats.value.userStats.STUDENT || 0, name: '学生' }
      ]
      userRoleChart.setOption({
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical',
          left: 'left'
        },
        series: [
          {
            name: '用户角色',
            type: 'pie',
            radius: '50%',
            data: userRoleData,
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: 'rgba(0, 0, 0, 0.5)'
              }
            }
          }
        ]
      })
      }

      // 题目类型分布图表
      if (questionTypeChartRef.value) {
      questionTypeChart = echarts.init(questionTypeChartRef.value)
      const questionTypeData = [
        { value: stats.value.questionTypeStats.SINGLE || 0, name: '单选题' },
        { value: stats.value.questionTypeStats.MULTIPLE || 0, name: '多选题' },
        { value: stats.value.questionTypeStats.JUDGE || 0, name: '判断题' },
        { value: stats.value.questionTypeStats.FILL || 0, name: '填空题' },
        { value: stats.value.questionTypeStats.ESSAY || 0, name: '主观题' }
      ]
      questionTypeChart.setOption({
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical',
          left: 'left'
        },
        series: [
          {
            name: '题目类型',
            type: 'pie',
            radius: '50%',
            data: questionTypeData,
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: 'rgba(0, 0, 0, 0.5)'
              }
            }
          }
        ]
      })
      }

      // 题目难度分布图表
      if (questionDifficultyChartRef.value) {
      questionDifficultyChart = echarts.init(questionDifficultyChartRef.value)
      const questionDifficultyData = [
        { value: stats.value.questionDifficultyStats.EASY || 0, name: '简单' },
        { value: stats.value.questionDifficultyStats.MEDIUM || 0, name: '中等' },
        { value: stats.value.questionDifficultyStats.HARD || 0, name: '困难' }
      ]
      questionDifficultyChart.setOption({
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical',
          left: 'left'
        },
        series: [
          {
            name: '题目难度',
            type: 'pie',
            radius: '50%',
            data: questionDifficultyData,
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: 'rgba(0, 0, 0, 0.5)'
              }
            }
          }
        ]
      })
      }

      // 考试状态分布图表
      if (examStatusChartRef.value) {
      examStatusChart = echarts.init(examStatusChartRef.value)
      const examStatusData = [
        { value: stats.value.examStatusStats.NOT_STARTED || 0, name: '未开始' },
        { value: stats.value.examStatusStats.IN_PROGRESS || 0, name: '进行中' },
        { value: stats.value.examStatusStats.FINISHED || 0, name: '已结束' }
      ]
      examStatusChart.setOption({
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical',
          left: 'left'
        },
        series: [
          {
            name: '考试状态',
            type: 'pie',
            radius: '50%',
            data: examStatusData,
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: 'rgba(0, 0, 0, 0.5)'
              }
            }
          }
        ]
      })
      }
    }
  })
}

const loadStatistics = async () => {
  try {
    const res = await getStatistics()
    if (res.data) {
      if (isStudent.value) {
        // 学生数据
        stats.value = {
          totalExams: res.data.totalExams || 0,
          finishedExamRecords: res.data.finishedExamRecords || 0,
          inProgressRecords: res.data.inProgressRecords || 0,
          totalExamRecords: res.data.totalExamRecords || 0,
          avgScore: res.data.avgScore || 0,
          maxScore: res.data.maxScore || 0,
          minScore: res.data.minScore || 0,
          totalScore: res.data.totalScore || 0,
          examCount: res.data.examCount || 0,
          knowledgePointErrors: res.data.knowledgePointErrors || {},
          examStatusStats: res.data.examStatusStats || {},
          wrongQuestionCount: res.data.wrongQuestionCount || 0,
          totalQuestionCount: res.data.totalQuestionCount || 0
        }
      } else {
        // 系统全局数据
        stats.value = {
          totalUsers: res.data.totalUsers || 0,
          totalQuestions: res.data.totalQuestions || 0,
          totalExams: res.data.totalExams || 0,
          totalPapers: res.data.totalPapers || 0,
          userStats: res.data.userStats || {},
          questionTypeStats: res.data.questionTypeStats || {},
          questionDifficultyStats: res.data.questionDifficultyStats || {},
          examStatusStats: res.data.examStatusStats || {},
          totalExamRecords: res.data.totalExamRecords || 0,
          finishedExamRecords: res.data.finishedExamRecords || 0,
          avgScore: res.data.avgScore || 0,
          maxScore: res.data.maxScore || 0,
          minScore: res.data.minScore || 0
        }
      }
      initCharts()
    }
  } catch (error) {
    console.error(error)
    ElMessage.error('加载统计数据失败')
  }
}

onMounted(() => {
  loadStatistics()
  
  // 窗口大小改变时重新调整图表
  window.addEventListener('resize', () => {
    if (userRoleChart) userRoleChart.resize()
    if (questionTypeChart) questionTypeChart.resize()
    if (questionDifficultyChart) questionDifficultyChart.resize()
    if (examStatusChart) examStatusChart.resize()
    if (knowledgePointChart) knowledgePointChart.resize()
  })
})
</script>

<style scoped>
.stat-item {
  text-align: center;
}

.stat-value {
  font-size: 32px;
  font-weight: bold;
  color: #409EFF;
}

.stat-label {
  font-size: 14px;
  color: #909399;
  margin-top: 10px;
}

.score-stat {
  text-align: center;
}

.score-label {
  font-size: 14px;
  color: #909399;
  margin-bottom: 10px;
}

.score-value {
  font-size: 24px;
  font-weight: bold;
  color: #409EFF;
}
</style>

