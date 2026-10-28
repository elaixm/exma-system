<template>
  <el-container>
    <el-aside width="200px">
      <el-menu
        :default-active="activeMenu"
        router
        background-color="#304156"
        text-color="#bfcbd9"
        active-text-color="#409EFF"
      >
        <div class="logo">
          <h2 style="color: white; text-align: center; padding: 20px 0;">考试系统</h2>
        </div>
        <el-menu-item index="/dashboard">
          <el-icon><House /></el-icon>
          <span>首页</span>
        </el-menu-item>
        <el-menu-item v-if="isAdmin" index="/users">
          <el-icon><User /></el-icon>
          <span>用户管理</span>
        </el-menu-item>
        <el-menu-item v-if="isTeacherOrAdmin" index="/questions">
          <el-icon><Document /></el-icon>
          <span>题库管理</span>
        </el-menu-item>
        <el-menu-item v-if="isTeacherOrAdmin" index="/papers">
          <el-icon><Files /></el-icon>
          <span>试卷管理</span>
        </el-menu-item>
        <el-menu-item index="/exams">
          <el-icon><Edit /></el-icon>
          <span>考试管理</span>
        </el-menu-item>
        <el-menu-item index="/scores">
          <el-icon><DataAnalysis /></el-icon>
          <span>成绩管理</span>
        </el-menu-item>
        <el-menu-item v-if="isStudent" index="/knowledge-graph">
          <el-icon><PieChart /></el-icon>
          <span>知识图谱</span>
        </el-menu-item>
        <el-menu-item v-if="isStudent" index="/wrong-book">
          <el-icon><Notebook /></el-icon>
          <span>错题本</span>
        </el-menu-item>
        <el-menu-item v-if="isTeacherOrAdmin" index="/exam-logs">
          <el-icon><DocumentCopy /></el-icon>
          <span>系统日志</span>
        </el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header>
        <div class="header-right">
          <span>欢迎，{{ userStore.realName || userStore.username }}</span>
          <el-button type="danger" @click="handleLogout">退出</el-button>
        </div>
      </el-header>
      <el-main>
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useUserStore } from '../stores/user'
import { ElMessage } from 'element-plus'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const activeMenu = computed(() => route.path)

const isAdmin = computed(() => userStore.role === 'ADMIN')
const isTeacherOrAdmin = computed(() => ['TEACHER', 'ADMIN'].includes(userStore.role))
const isStudent = computed(() => userStore.role === 'STUDENT')

const handleLogout = () => {
  userStore.logout()
  ElMessage.success('退出成功')
  router.push('/login')
}
</script>

<style scoped>
.el-container {
  height: 100vh;
}

.el-aside {
  background-color: #304156;
}

.el-header {
  background-color: #fff;
  display: flex;
  justify-content: flex-end;
  align-items: center;
  border-bottom: 1px solid #e4e7ed;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 20px;
}

.logo {
  border-bottom: 1px solid #434a55;
}
</style>

