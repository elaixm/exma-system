<template>
  <div>
    <el-card>
      <template #header>
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <span>系统日志管理</span>
        </div>
      </template>
      <el-form :inline="true" style="margin-bottom: 20px;">
        <el-form-item label="考试">
          <el-select v-model="searchForm.examId" clearable placeholder="请选择考试" style="width: 250px;" filterable>
            <el-option
              v-for="exam in examList"
              :key="exam.id"
              :label="exam.title"
              :value="exam.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="学生">
          <el-select v-model="searchForm.studentId" clearable placeholder="请选择学生" style="width: 250px;" filterable>
            <el-option
              v-for="student in studentList"
              :key="student.id"
              :label="`${student.realName} (${student.username})`"
              :value="student.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
      <el-table :data="tableData" border style="width: 100%;" v-loading="loading">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="examId" label="考试ID" width="100" />
        <el-table-column label="考试名称" width="200">
          <template #default="{ row }">
            {{ getExamName(row.examId) }}
          </template>
        </el-table-column>
        <el-table-column prop="studentId" label="学生ID" width="100" />
        <el-table-column label="学生姓名" width="150">
          <template #default="{ row }">
            {{ getStudentName(row.studentId) }}
          </template>
        </el-table-column>
        <el-table-column prop="action" label="操作类型" width="150">
          <template #default="{ row }">
            <el-tag v-if="row.action === 'START_EXAM'" type="success">开始考试</el-tag>
            <el-tag v-else-if="row.action === 'SAVE_ANSWER'" type="info">保存答案</el-tag>
            <el-tag v-else-if="row.action === 'SUBMIT_EXAM'" type="warning">提交考试</el-tag>
            <el-tag v-else-if="row.action === 'PAGE_VISIBILITY_CHANGE'" type="danger">页面切换</el-tag>
            <el-tag v-else-if="row.action === 'ANSWER_CHANGE'" type="primary">答案修改</el-tag>
            <el-tag v-else>{{ row.action }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="detail" label="操作详情" min-width="200" show-overflow-tooltip />
        <el-table-column prop="ipAddress" label="IP地址" width="150" />
        <el-table-column prop="createTime" label="操作时间" width="180" />
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button size="small" @click="handleViewDetail(row)">查看详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination
        v-model:current-page="pagination.page"
        v-model:page-size="pagination.size"
        :total="pagination.total"
        @current-change="loadData"
        @size-change="loadData"
        style="margin-top: 20px;"
        :page-sizes="[10, 20, 50, 100]"
      />
    </el-card>

    <el-dialog v-model="detailDialogVisible" title="日志详情" width="800px">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="日志ID">{{ currentLog.id }}</el-descriptions-item>
        <el-descriptions-item label="考试ID">{{ currentLog.examId }}</el-descriptions-item>
        <el-descriptions-item label="考试名称">{{ getExamName(currentLog.examId) }}</el-descriptions-item>
        <el-descriptions-item label="学生ID">{{ currentLog.studentId }}</el-descriptions-item>
        <el-descriptions-item label="学生姓名">{{ getStudentName(currentLog.studentId) }}</el-descriptions-item>
        <el-descriptions-item label="操作类型">
          <el-tag v-if="currentLog.action === 'START_EXAM'" type="success">开始考试</el-tag>
          <el-tag v-else-if="currentLog.action === 'SAVE_ANSWER'" type="info">保存答案</el-tag>
          <el-tag v-else-if="currentLog.action === 'SUBMIT_EXAM'" type="warning">提交考试</el-tag>
          <el-tag v-else-if="currentLog.action === 'PAGE_VISIBILITY_CHANGE'" type="danger">页面切换</el-tag>
          <el-tag v-else-if="currentLog.action === 'ANSWER_CHANGE'" type="primary">答案修改</el-tag>
          <el-tag v-else>{{ currentLog.action }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="操作详情" :span="2">{{ currentLog.detail }}</el-descriptions-item>
        <el-descriptions-item label="IP地址">{{ currentLog.ipAddress }}</el-descriptions-item>
        <el-descriptions-item label="操作时间">{{ currentLog.createTime }}</el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <el-button @click="detailDialogVisible = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getExamLogList } from '../api/examLog'
import { getExamList } from '../api/exam'
import { getUserList } from '../api/user'

const tableData = ref([])
const loading = ref(false)
const detailDialogVisible = ref(false)
const currentLog = ref({})
const examList = ref([])
const studentList = ref([])

const searchForm = ref({
  examId: null,
  studentId: null
})

const pagination = ref({
  page: 1,
  size: 20,
  total: 0
})

const loadData = async () => {
  loading.value = true
  try {
    const params = {
      page: pagination.value.page,
      size: pagination.value.size,
      ...searchForm.value
    }
    // 移除null值
    Object.keys(params).forEach(key => {
      if (params[key] === null || params[key] === undefined || params[key] === '') {
        delete params[key]
      }
    })
    
    const res = await getExamLogList(params)
    tableData.value = res.data.records || []
    pagination.value.total = res.data.total || 0
  } catch (error) {
    console.error(error)
    ElMessage.error('加载日志失败')
  } finally {
    loading.value = false
  }
}

const loadExams = async () => {
  try {
    const res = await getExamList({ page: 1, size: 1000 })
    examList.value = res.data.records || []
  } catch (error) {
    console.error(error)
  }
}

const loadStudents = async () => {
  try {
    const res = await getUserList({ page: 1, size: 1000, role: 'STUDENT' })
    studentList.value = res.data.records || []
  } catch (error) {
    console.error(error)
  }
}

const getExamName = (examId) => {
  const exam = examList.value.find(e => e.id === examId)
  return exam ? exam.title : `考试ID: ${examId}`
}

const getStudentName = (studentId) => {
  const student = studentList.value.find(s => s.id === studentId)
  return student ? `${student.realName} (${student.username})` : `学生ID: ${studentId}`
}

const handleSearch = () => {
  pagination.value.page = 1
  loadData()
}

const handleReset = () => {
  searchForm.value = {
    examId: null,
    studentId: null
  }
  pagination.value.page = 1
  loadData()
}

const handleViewDetail = (row) => {
  currentLog.value = { ...row }
  detailDialogVisible.value = true
}

onMounted(() => {
  loadExams()
  loadStudents()
  loadData()
})
</script>

<style scoped>
</style>

