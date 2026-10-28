<template>
  <div>
    <el-card>
      <template #header>
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <span>题库管理</span>
          <div>
            <el-button @click="handleImport">批量导入</el-button>
            <el-button @click="handleExport">导出</el-button>
            <el-button type="primary" @click="handleAdd">新增题目</el-button>
          </div>
        </div>
      </template>
      <el-form :inline="true" style="margin-bottom: 20px;">
        <el-form-item label="题型">
          <el-select v-model="searchForm.type" clearable placeholder="请选择" style="width: 200px;">
            <el-option label="单选题" value="SINGLE" />
            <el-option label="多选题" value="MULTIPLE" />
            <el-option label="判断题" value="JUDGE" />
            <el-option label="填空题" value="FILL" />
            <el-option label="简答题" value="ESSAY" />
          </el-select>
        </el-form-item>
        <el-form-item label="关键词">
          <el-input v-model="searchForm.keyword" placeholder="题目内容/知识点" style="width: 200px;" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
        </el-form-item>
      </el-form>
      <el-table :data="tableData" border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="type" label="题型" width="100">
          <template #default="{ row }">
            <el-tag v-if="row.type === 'SINGLE'">单选题</el-tag>
            <el-tag v-else-if="row.type === 'MULTIPLE'" type="success">多选题</el-tag>
            <el-tag v-else-if="row.type === 'JUDGE'" type="warning">判断题</el-tag>
            <el-tag v-else-if="row.type === 'FILL'" type="info">填空题</el-tag>
            <el-tag v-else type="danger">简答题</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="content" label="题目内容" show-overflow-tooltip />
        <el-table-column prop="score" label="分值" width="80" />
        <el-table-column prop="difficulty" label="难度" width="100" />
        <el-table-column prop="knowledgePoint" label="知识点" />
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button size="small" type="danger" @click="handleDelete(row)">删除</el-button>
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
        <el-form-item label="题型" prop="type">
          <el-select v-model="form.type" style="width: 100%;">
            <el-option label="单选题" value="SINGLE" />
            <el-option label="多选题" value="MULTIPLE" />
            <el-option label="判断题" value="JUDGE" />
            <el-option label="填空题" value="FILL" />
            <el-option label="简答题" value="ESSAY" />
          </el-select>
        </el-form-item>
        <el-form-item label="题目内容" prop="content">
          <el-input v-model="form.content" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="选项" v-if="form.type === 'SINGLE' || form.type === 'MULTIPLE'">
          <el-input v-model="form.options" type="textarea" :rows="4" placeholder="每行一个选项，如：A.选项1&#10;B.选项2" />
        </el-form-item>
        <el-form-item label="正确答案" prop="answer">
          <el-input v-model="form.answer" placeholder="单选题/判断题/填空题填答案，多选题用逗号分隔，如：A,B" />
        </el-form-item>
        <el-form-item label="解析">
          <el-input v-model="form.analysis" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="分值" prop="score">
          <el-input-number v-model="form.score" :min="1" />
        </el-form-item>
        <el-form-item label="难度">
          <el-select v-model="form.difficulty" style="width: 100%;">
            <el-option label="简单" value="EASY" />
            <el-option label="中等" value="MEDIUM" />
            <el-option label="困难" value="HARD" />
          </el-select>
        </el-form-item>
        <el-form-item label="知识点">
          <el-input v-model="form.knowledgePoint" />
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
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getQuestionList, saveQuestion, updateQuestion, deleteQuestion, batchImport, exportQuestions } from '../api/question'

const tableData = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const formRef = ref()

const searchForm = ref({
  type: '',
  keyword: ''
})

const pagination = ref({
  page: 1,
  size: 10,
  total: 0
})

const form = ref({
  id: null,
  type: 'SINGLE',
  content: '',
  options: '',
  answer: '',
  analysis: '',
  score: 5,
  difficulty: 'MEDIUM',
  knowledgePoint: ''
})

const rules = {
  type: [{ required: true, message: '请选择题型', trigger: 'change' }],
  content: [{ required: true, message: '请输入题目内容', trigger: 'blur' }],
  answer: [{ required: true, message: '请输入正确答案', trigger: 'blur' }],
  score: [{ required: true, message: '请输入分值', trigger: 'blur' }]
}

const loadData = async () => {
  try {
    const res = await getQuestionList({
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

const handleSearch = () => {
  pagination.value.page = 1
  loadData()
}

const handleAdd = () => {
  dialogTitle.value = '新增题目'
  form.value = {
    id: null,
    type: 'SINGLE',
    content: '',
    options: '',
    answer: '',
    analysis: '',
    score: 5,
    difficulty: 'MEDIUM',
    knowledgePoint: ''
  }
  dialogVisible.value = true
}

const handleEdit = (row) => {
  dialogTitle.value = '编辑题目'
  form.value = { ...row }
  dialogVisible.value = true
}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确定要删除该题目吗？', '提示', {
      type: 'warning'
    })
    await deleteQuestion(row.id)
    ElMessage.success('删除成功')
    loadData()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const handleSubmit = async () => {
  await formRef.value.validate(async (valid) => {
    if (valid) {
      try {
        if (form.value.id) {
          await updateQuestion(form.value.id, form.value)
          ElMessage.success('更新成功')
        } else {
          await saveQuestion(form.value)
          ElMessage.success('创建成功')
        }
        dialogVisible.value = false
        loadData()
      } catch (error) {
        ElMessage.error('操作失败')
      }
    }
  })
}

const handleImport = () => {
  const input = document.createElement('input')
  input.type = 'file'
  input.accept = '.xlsx,.xls'
  input.onchange = async (e) => {
    const file = e.target.files[0]
    if (file) {
      try {
        const res = await batchImport(file)
        ElMessage.success(res.message || '导入成功')
        loadData()
      } catch (error) {
        ElMessage.error(error.message || '导入失败')
      }
    }
  }
  input.click()
}

const handleExport = async () => {
  try {
    const response = await exportQuestions()
    const blob = new Blob([response], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' })
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = '题库导出.xlsx'
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success('导出成功')
  } catch (error) {
    ElMessage.error(error.message || '导出失败')
  }
}

onMounted(() => {
  loadData()
})
</script>

