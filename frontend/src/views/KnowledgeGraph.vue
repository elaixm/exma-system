<template>
  <div>
    <el-card>
      <template #header>
        <span>个人知识图谱</span>
      </template>
      <div v-loading="loading" style="min-height: 600px;">
        <div v-if="!loading && knowledgePointsList.length > 0">
          <div id="knowledgeGraph" style="width: 100%; height: 600px;"></div>
        </div>
        <div v-if="!loading && knowledgePointsList.length === 0" style="text-align: center; padding: 50px; color: #909399;">
          暂无错题数据，无法生成知识图谱
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'
import * as echarts from 'echarts'
import { getKnowledgeGraph } from '../api/score'
import { getCurrentUser } from '../api/user'
import { ElMessage } from 'element-plus'

const loading = ref(true)
const knowledgePointsList = ref([])

onMounted(async () => {
  try {
    console.log('========== 知识图谱页面加载开始 ==========')
    const userRes = await getCurrentUser()
    console.log('当前用户信息:', userRes.data)
    const userId = userRes.data.id
    console.log('用户ID:', userId)
    
    console.log('开始调用知识图谱API...')
    const res = await getKnowledgeGraph(userId)
    console.log('知识图谱API响应:', res)
    console.log('响应数据:', res.data)
    
    const knowledgePoints = res.data.knowledgePoints || {}
    console.log('知识点数据:', knowledgePoints)
    
    knowledgePointsList.value = Object.entries(knowledgePoints).map(([name, value]) => ({
      name,
      value
    }))
    console.log('知识点列表:', knowledgePointsList.value)
    console.log('知识点数量:', knowledgePointsList.value.length)
    
    // 先设置loading为false，让DOM渲染
    loading.value = false
    
    if (knowledgePointsList.value.length > 0) {
      // 等待DOM渲染完成
      await nextTick()
      // 再次等待一个tick，确保DOM完全渲染
      await new Promise(resolve => setTimeout(resolve, 100))
      
      console.log('开始初始化图表...')
      const chartDom = document.getElementById('knowledgeGraph')
      console.log('查找图表容器，结果:', chartDom)
      
      if (!chartDom) {
        console.error('图表容器不存在，尝试延迟初始化...')
        // 如果还是找不到，再等一会儿
        await new Promise(resolve => setTimeout(resolve, 200))
        const chartDomRetry = document.getElementById('knowledgeGraph')
        if (!chartDomRetry) {
          console.error('重试后图表容器仍然不存在')
          ElMessage.error('图表容器不存在，请刷新页面重试')
          return
        }
        initChart(chartDomRetry)
      } else {
        initChart(chartDom)
      }
    } else {
      console.log('没有知识点数据，显示空状态')
    }
    
    console.log('========== 知识图谱页面加载完成 ==========')
  } catch (error) {
    console.error('========== 知识图谱页面加载失败 ==========')
    console.error('错误信息:', error)
    console.error('错误堆栈:', error.stack)
    console.error('错误响应:', error.response)
    ElMessage.error('加载知识图谱失败: ' + (error.message || '未知错误'))
    loading.value = false
  }
})

const initChart = (chartDom) => {
  try {
    console.log('开始初始化ECharts图表，容器:', chartDom)
    const chart = echarts.init(chartDom)
    console.log('图表初始化成功')
    
    const option = {
      title: {
        text: '薄弱知识点分析',
        left: 'center',
        textStyle: {
          fontSize: 18
        }
      },
      tooltip: {
        trigger: 'item',
        formatter: '{a} <br/>{b}: {c} ({d}%)'
      },
      legend: {
        orient: 'vertical',
        left: 'left',
        top: 'middle'
      },
      series: [
        {
          name: '错题数',
          type: 'pie',
          radius: ['40%', '70%'],
          avoidLabelOverlap: false,
          itemStyle: {
            borderRadius: 10,
            borderColor: '#fff',
            borderWidth: 2
          },
          label: {
            show: true,
            formatter: '{b}: {c}题'
          },
          emphasis: {
            label: {
              show: true,
              fontSize: 16,
              fontWeight: 'bold'
            }
          },
          data: knowledgePointsList.value
        }
      ]
    }
    
    console.log('图表配置:', option)
    chart.setOption(option)
    console.log('图表设置成功')
    
    // 保存resize监听器，避免重复添加
    const resizeHandler = () => {
      chart.resize()
    }
    window.addEventListener('resize', resizeHandler)
    
    console.log('图表初始化完成')
  } catch (error) {
    console.error('图表初始化失败:', error)
    ElMessage.error('图表初始化失败: ' + error.message)
  }
}
</script>

