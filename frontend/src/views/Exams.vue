<template>
  <div>
    <el-card>
      <template #header>
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <span>考试管理</span>
          <el-button v-if="isTeacherOrAdmin" type="primary" @click="handleAdd">新增考试</el-button>
        </div>
      </template>
      <el-form :inline="true" style="margin-bottom: 20px;">
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" clearable placeholder="请选择" style="width: 200px;">
            <el-option label="未开始" value="NOT_STARTED" />
            <el-option label="进行中" value="IN_PROGRESS" />
            <el-option label="已结束" value="FINISHED" />
          </el-select>
        </el-form-item>
        <el-form-item label="关键词">
          <el-input v-model="searchForm.keyword" placeholder="考试名称" style="width: 200px;" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
        </el-form-item>
      </el-form>
      <el-table :data="tableData" border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="title" label="考试名称" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag v-if="row.status === 'NOT_STARTED'">未开始</el-tag>
            <el-tag v-else-if="row.status === 'IN_PROGRESS'" type="warning">进行中</el-tag>
            <el-tag v-else type="success">已结束</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="startTime" label="开始时间" width="180" />
        <el-table-column prop="endTime" label="结束时间" width="180" />
        <el-table-column prop="duration" label="时长(分钟)" width="120" />
        <el-table-column label="操作" width="300">
          <template #default="{ row }">
            <el-button v-if="isStudent && canEnterExam(row)" size="small" type="primary" @click="handleStartExam(row)">进入考试</el-button>
            <el-tag v-if="isStudent && row.status === 'NOT_STARTED'" type="info" size="small">未开始</el-tag>
            <el-tag v-if="isStudent && isExamExpired(row)" type="danger" size="small">已过期</el-tag>
            <el-tag v-if="isStudent && row.status === 'FINISHED'" type="success" size="small">已结束</el-tag>
            <el-button v-if="isTeacherOrAdmin" size="small" @click="handleView(row)">查看</el-button>
            <el-button v-if="isTeacherOrAdmin" size="small" @click="handleViewLogs(row)">查看日志</el-button>
            <el-button v-if="isTeacherOrAdmin" size="small" @click="handleViewRecords(row)">查看记录</el-button>
            <el-button v-if="isTeacherOrAdmin && row.status === 'NOT_STARTED'" size="small" type="warning" @click="handleUpdateStatus(row, 'IN_PROGRESS')">开始</el-button>
            <el-button v-if="isTeacherOrAdmin && row.status !== 'FINISHED'" size="small" type="danger" @click="handleUpdateStatus(row, 'FINISHED')">结束</el-button>
            <el-button v-if="isTeacherOrAdmin" size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button v-if="isTeacherOrAdmin" size="small" type="danger" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination
        v-model:current-page="pagination.page"
        v-model:page-size="pagination.size"
        :total="pagination.total"
        @current-change="loadData"
        style="margin-top: 20px;"
      />
    </el-card>

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="800px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="考试名称" prop="title">
          <el-input v-model="form.title" />
        </el-form-item>
        <el-form-item label="考试描述">
          <el-input v-model="form.description" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="试卷" prop="paperId">
          <el-select v-model="form.paperId" style="width: 100%;" filterable>
            <el-option
              v-for="paper in paperList"
              :key="paper.id"
              :label="paper.title"
              :value="paper.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="开始时间" prop="startTime">
          <el-date-picker
            v-model="form.startTime"
            type="datetime"
            style="width: 100%;"
            placeholder="选择开始时间"
            :disabled-date="disabledStartDate"
            @change="handleStartTimeChange"
          />
        </el-form-item>
        <el-form-item label="结束时间" prop="endTime">
          <el-date-picker
            v-model="form.endTime"
            type="datetime"
            style="width: 100%;"
            placeholder="选择结束时间"
            :disabled-date="disabledEndDate"
          />
        </el-form-item>
        <el-form-item label="时长(分钟)" prop="duration">
          <el-input-number v-model="form.duration" :min="1" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getExamList, createExam, updateExam, deleteExam, startExam, getExamLogs, getExamRecords, updateExamStatus } from '../api/exam'
import { getClassWeakness } from '../api/score'
import { getPaperList } from '../api/paper'
import { useUserStore } from '../stores/user'

const router = useRouter()
const userStore = useUserStore()

const tableData = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref()
const paperList = ref([])

const isTeacherOrAdmin = computed(() => ['TEACHER', 'ADMIN'].includes(userStore.role))
const isStudent = computed(() => userStore.role === 'STUDENT')

// 判断考试是否真正可以进行（状态为进行中且在时间范围内）
const canEnterExam = (row) => {
  if (row.status !== 'IN_PROGRESS') return false
  const now = new Date()
  const startTime = row.startTime ? new Date(row.startTime) : null
  const endTime = row.endTime ? new Date(row.endTime) : null
  if (startTime && now < startTime) return false
  if (endTime && now > endTime) return false
  return true
}

// 判断考试是否已过期（状态显示进行中但实际已过结束时间）
const isExamExpired = (row) => {
  if (row.status !== 'IN_PROGRESS') return false
  const endTime = row.endTime ? new Date(row.endTime) : null
  return endTime && new Date() > endTime
}

// 禁用今天之前的日期（开始时间）
const disabledStartDate = (date) => {
  return date.getTime() < Date.now() - 24 * 60 * 60 * 1000
}

// 禁用开始时间之前的日期（结束时间）
const disabledEndDate = (date) => {
  if (form.value.startTime) {
    return date.getTime() < new Date(form.value.startTime).getTime() - 24 * 60 * 60 * 1000
  }
  return date.getTime() < Date.now() - 24 * 60 * 60 * 1000
}

// 开始时间变更时，如果结束时间早于开始时间则清空
const handleStartTimeChange = () => {
  if (form.value.endTime && new Date(form.value.endTime) <= new Date(form.value.startTime)) {
    form.value.endTime = null
  }
}

const searchForm = ref({
  status: '',
  keyword: ''
})

const pagination = ref({
  page: 1,
  size: 10,
  total: 0
})

const form = ref({
  id: null,
  title: '',
  description: '',
  paperId: null,
  startTime: null,
  endTime: null,
  duration: 60
})

const rules = {
  title: [{ required: true, message: '请输入考试名称', trigger: 'blur' }],
  paperId: [{ required: true, message: '请选择试卷', trigger: 'change' }],
  startTime: [{ required: true, message: '请选择开始时间', trigger: 'change' }],
  endTime: [
    { required: true, message: '请选择结束时间', trigger: 'change' },
    {
      validator: (rule, value, callback) => {
        if (value && form.value.startTime && new Date(value) <= new Date(form.value.startTime)) {
          callback(new Error('结束时间必须晚于开始时间'))
        } else {
          callback()
        }
      },
      trigger: 'change'
    }
  ],
  duration: [{ required: true, message: '请输入时长', trigger: 'blur' }]
}

const loadData = async () => {
  try {
    const res = await getExamList({
      page: pagination.value.page,
      size: pagination.value.size,
      ...searchForm.value
    })
    tableData.value = res.data.records
    pagination.value.total = res.data.total
  } catch (error) {
    ElMessage.error('加载失败')
  }
}

const loadPapers = async () => {
  try {
    const res = await getPaperList({ page: 1, size: 1000 })
    paperList.value = res.data.records
  } catch (error) {
    console.error(error)
  }
}

const handleSearch = () => {
  pagination.value.page = 1
  loadData()
}

const handleAdd = () => {
  dialogTitle.value = '新增考试'
  form.value = {
    id: null,
    title: '',
    description: '',
    paperId: null,
    startTime: null,
    endTime: null,
    duration: 60
  }
  dialogVisible.value = true
}

const handleView = async (row) => {
  try {
    const weaknessRes = await getClassWeakness(row.id)
    ElMessageBox.alert(
      `<div><h3>班级薄弱点分析</h3><pre>${JSON.stringify(weaknessRes.data, null, 2)}</pre></div>`,
      '考试分析',
      { dangerouslyUseHTMLString: true }
    )
  } catch (error) {
    ElMessage.error('加载分析数据失败')
  }
}

const handleViewLogs = async (row) => {
  try {
    const res = await getExamLogs(row.id)
    const logs = res.data || []
    const logText = logs.map(log => 
      `${log.createTime}: ${log.action} - ${log.detail} (IP: ${log.ipAddress})`
    ).join('\n')
    ElMessageBox.alert(
      `<div><h3>考试日志</h3><pre style="max-height: 400px; overflow-y: auto;">${logText || '暂无日志'}</pre></div>`,
      '考试日志',
      { dangerouslyUseHTMLString: true, width: '600px' }
    )
  } catch (error) {
    ElMessage.error('加载日志失败')
  }
}

const handleViewRecords = async (row) => {
  try {
    const res = await getExamRecords(row.id)
    const records = res.data || []
    const recordText = records.map(record => 
      `学生ID: ${record.studentId}, 分数: ${record.score || '未评分'}, 状态: ${record.status}, 提交时间: ${record.submitTime || '未提交'}`
    ).join('\n')
    ElMessageBox.alert(
      `<div><h3>考试记录</h3><pre style="max-height: 400px; overflow-y: auto;">${recordText || '暂无记录'}</pre></div>`,
      '考试记录',
      { dangerouslyUseHTMLString: true, width: '600px' }
    )
  } catch (error) {
    ElMessage.error('加载记录失败')
  }
}

const handleEdit = (row) => {
  dialogTitle.value = '编辑考试'
  form.value = { ...row }
  dialogVisible.value = true
}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确定要删除该考试吗？', '提示', {
      type: 'warning'
    })
    await deleteExam(row.id)
    ElMessage.success('删除成功')
    loadData()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const handleStartExam = async (row) => {
  try {
    await startExam(row.id)
    router.push(`/exam/${row.id}`)
  } catch (error) {
    const msg = error.response?.data?.message || error.message || '开始考试失败'
    ElMessage.error(msg)
  }
}

const handleUpdateStatus = async (row, newStatus) => {
  try {
    const statusText = newStatus === 'IN_PROGRESS' ? '开始' : '结束'
    await ElMessageBox.confirm(`确定要${statusText}该考试吗？`, '提示', {
      type: 'warning'
    })
    await updateExamStatus(row.id, { status: newStatus })
    ElMessage.success(`${statusText}考试成功`)
    loadData()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('操作失败')
    }
  }
}

const formatDateTime = (date) => {
  if (!date) return null
  const d = new Date(date)
  const year = d.getFullYear()
  const month = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  const hour = String(d.getHours()).padStart(2, '0')
  const minute = String(d.getMinutes()).padStart(2, '0')
  const second = String(d.getSeconds()).padStart(2, '0')
  return `${year}-${month}-${day}T${hour}:${minute}:${second}`
}

const handleSubmit = async () => {
  await formRef.value.validate(async (valid) => {
    if (valid) {
      try {
        // 格式化时间数据
        const submitData = {
          ...form.value,
          startTime: formatDateTime(form.value.startTime),
          endTime: formatDateTime(form.value.endTime)
        }
        
        if (form.value.id) {
          await updateExam(form.value.id, submitData)
          ElMessage.success('更新成功')
        } else {
          await createExam(submitData)
          ElMessage.success('创建成功')
        }
        dialogVisible.value = false
        loadData()
      } catch (error) {
        ElMessage.error(error.response?.data?.message || '操作失败')
      }
    }
  })
}

onMounted(() => {
  loadData()
  if (isTeacherOrAdmin.value) {
    loadPapers()
  }
})
</script>

