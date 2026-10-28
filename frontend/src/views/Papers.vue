<template>
  <div>
    <el-card>
      <template #header>
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <span>试卷管理</span>
          <div>
            <el-button type="success" @click="showRandomDialog = true">随机组卷</el-button>
            <el-button type="primary" @click="handleAdd">新增试卷</el-button>
          </div>
        </div>
      </template>
      <el-form :inline="true" style="margin-bottom: 20px;">
        <el-form-item label="关键词">
          <el-input v-model="searchForm.keyword" placeholder="试卷名称" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
        </el-form-item>
      </el-form>
      <el-table :data="tableData" border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="title" label="试卷名称" />
        <el-table-column prop="type" label="类型" width="100">
          <template #default="{ row }">
            <el-tag v-if="row.type === 'FIXED'">固定组卷</el-tag>
            <el-tag v-else type="success">随机组卷</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="totalScore" label="总分" width="100" />
        <el-table-column prop="duration" label="时长(分钟)" width="120" />
        <el-table-column label="操作" width="250">
          <template #default="{ row }">
            <el-button size="small" @click="handleView(row)">查看</el-button>
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
        <el-form-item label="试卷名称" prop="title">
          <el-input v-model="form.title" />
        </el-form-item>
        <el-form-item label="试卷描述">
          <el-input v-model="form.description" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="类型" prop="type">
          <el-select v-model="form.type" style="width: 100%;">
            <el-option label="固定组卷" value="FIXED" />
            <el-option label="随机组卷" value="RANDOM" />
          </el-select>
        </el-form-item>
        <el-form-item label="题目ID" v-if="form.type === 'FIXED'">
          <el-input v-model="form.questionIds" placeholder="用逗号分隔，如：1,2,3" />
        </el-form-item>
        <el-form-item label="总分" prop="totalScore">
          <el-input-number v-model="form.totalScore" :min="1" />
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

    <el-dialog v-model="showRandomDialog" title="随机组卷" width="600px">
      <el-form :model="randomForm" :rules="randomRules" ref="randomFormRef" label-width="120px">
        <el-form-item label="生成试卷数" prop="paperCount">
          <el-input-number v-model="randomForm.paperCount" :min="1" :max="10" />
        </el-form-item>
        <el-form-item label="目标总分" prop="targetScore">
          <el-input-number v-model="randomForm.targetScore" :min="1" />
        </el-form-item>
        <el-form-item label="难度分布">
          <el-input-number v-model="randomForm.difficultyDistribution.EASY" placeholder="简单题数量" style="width: 100%; margin-bottom: 10px;" />
          <el-input-number v-model="randomForm.difficultyDistribution.MEDIUM" placeholder="中等题数量" style="width: 100%; margin-bottom: 10px;" />
          <el-input-number v-model="randomForm.difficultyDistribution.HARD" placeholder="困难题数量" style="width: 100%;" />
        </el-form-item>
        <el-form-item label="必含知识点">
          <el-input v-model="randomForm.requiredKnowledgePoints" type="textarea" :rows="3" placeholder="每行一个知识点" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showRandomDialog = false">取消</el-button>
        <el-button type="primary" @click="handleGenerateRandom">生成</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getPaperList, getPaperById, savePaper, updatePaper, deletePaper, generateRandomPapers } from '../api/paper'

const tableData = ref([])
const dialogVisible = ref(false)
const showRandomDialog = ref(false)
const dialogTitle = ref('')
const formRef = ref()
const randomFormRef = ref()

const searchForm = ref({
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
  type: 'FIXED',
  questionIds: '',
  totalScore: 100,
  duration: 60
})

const randomForm = ref({
  paperCount: 3,
  targetScore: 100,
  difficultyDistribution: {
    EASY: 0,
    MEDIUM: 0,
    HARD: 0
  },
  requiredKnowledgePoints: ''
})

const rules = {
  title: [{ required: true, message: '请输入试卷名称', trigger: 'blur' }],
  type: [{ required: true, message: '请选择类型', trigger: 'change' }],
  totalScore: [{ required: true, message: '请输入总分', trigger: 'blur' }],
  duration: [{ required: true, message: '请输入时长', trigger: 'blur' }]
}

const randomRules = {
  paperCount: [{ required: true, message: '请输入试卷数', trigger: 'blur' }],
  targetScore: [{ required: true, message: '请输入目标总分', trigger: 'blur' }]
}

const loadData = async () => {
  try {
    const res = await getPaperList({
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
  dialogTitle.value = '新增试卷'
  form.value = {
    id: null,
    title: '',
    description: '',
    type: 'FIXED',
    questionIds: '',
    totalScore: 100,
    duration: 60
  }
  dialogVisible.value = true
}

const handleView = async (row) => {
  try {
    const paper = await getPaperById(row.id)
    const questionIds = paper.data.questionIds ? paper.data.questionIds.split(',').map(id => id.trim()) : []
    const { getAllQuestions } = await import('../api/question')
    const allQuestionsRes = await getAllQuestions()
    const allQuestions = allQuestionsRes.data || []
    const questions = questionIds.map(id => allQuestions.find(q => q.id === parseInt(id))).filter(q => q)
    
    const questionText = questions.map((q, index) => 
      `${index + 1}. [${q.type}] ${q.content} (分值: ${q.score}, 难度: ${q.difficulty}, 知识点: ${q.knowledgePoint})`
    ).join('\n\n')
    
    ElMessageBox.alert(
      `<div><h3>${paper.data.title}</h3><p>${paper.data.description || ''}</p><p>总分: ${paper.data.totalScore}, 时长: ${paper.data.duration}分钟</p><pre style="max-height: 400px; overflow-y: auto; white-space: pre-wrap;">${questionText || '暂无题目'}</pre></div>`,
      '试卷详情',
      { dangerouslyUseHTMLString: true, width: '800px' }
    )
  } catch (error) {
    ElMessage.error('加载试卷详情失败')
  }
}

const handleEdit = (row) => {
  dialogTitle.value = '编辑试卷'
  form.value = { ...row }
  dialogVisible.value = true
}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确定要删除该试卷吗？', '提示', {
      type: 'warning'
    })
    await deletePaper(row.id)
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
          await updatePaper(form.value.id, form.value)
          ElMessage.success('更新成功')
        } else {
          await savePaper(form.value)
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

const handleGenerateRandom = async () => {
  await randomFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        const params = {
          paperCount: randomForm.value.paperCount,
          targetScore: randomForm.value.targetScore,
          difficultyDistribution: randomForm.value.difficultyDistribution,
          requiredKnowledgePoints: randomForm.value.requiredKnowledgePoints
            ? randomForm.value.requiredKnowledgePoints.split('\n').filter(s => s.trim())
            : []
        }
        await generateRandomPapers(params)
        ElMessage.success('生成成功')
        showRandomDialog.value = false
        loadData()
      } catch (error) {
        ElMessage.error('生成失败')
      }
    }
  })
}

onMounted(() => {
  loadData()
})
</script>

