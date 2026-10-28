<template>
  <div class="login-container">
    <div class="login-background" :style="{ backgroundImage: `url(${bgImageUrl})` }"></div>
    <div class="login-wrapper">
      <el-card class="login-card" shadow="always">
        <template #header>
          <div class="login-header">
            <div class="logo-icon">
              <el-icon :size="40"><Document /></el-icon>
            </div>
            <h2 class="login-title">在线考试系统</h2>
            <p class="login-subtitle">Online Examination System</p>
          </div>
        </template>
        <el-tabs v-model="activeTab" class="login-tabs">
          <el-tab-pane label="登录" name="login">
            <el-form :model="loginForm" :rules="loginRules" ref="loginFormRef" label-width="0" class="login-form">
              <el-form-item prop="username">
                <el-input 
                  v-model="loginForm.username" 
                  placeholder="请输入用户名"
                  size="large"
                  :prefix-icon="User"
                  clearable
                />
              </el-form-item>
              <el-form-item prop="password">
                <el-input 
                  v-model="loginForm.password" 
                  type="password" 
                  placeholder="请输入密码"
                  size="large"
                  :prefix-icon="Lock"
                  show-password
                  @keyup.enter="handleLogin"
                />
              </el-form-item>
              <el-form-item>
                <el-button 
                  type="primary" 
                  @click="handleLogin" 
                  class="login-button"
                  size="large"
                  :loading="loginLoading"
                >
                  登录
                </el-button>
              </el-form-item>
            </el-form>
          </el-tab-pane>
          <el-tab-pane label="注册" name="register">
            <el-form :model="registerForm" :rules="registerRules" ref="registerFormRef" label-width="0" class="login-form">
              <el-form-item prop="username">
                <el-input 
                  v-model="registerForm.username" 
                  placeholder="请输入用户名"
                  size="large"
                  :prefix-icon="User"
                  clearable
                />
              </el-form-item>
              <el-form-item prop="password">
                <el-input 
                  v-model="registerForm.password" 
                  type="password" 
                  placeholder="请输入密码"
                  size="large"
                  :prefix-icon="Lock"
                  show-password
                />
              </el-form-item>
              <el-form-item prop="realName">
                <el-input 
                  v-model="registerForm.realName" 
                  placeholder="请输入真实姓名"
                  size="large"
                  :prefix-icon="Avatar"
                  clearable
                />
              </el-form-item>
              <el-form-item prop="role">
                <el-select 
                  v-model="registerForm.role" 
                  placeholder="请选择角色"
                  size="large"
                  style="width: 100%;"
                >
                  <el-option label="学生" value="STUDENT" />
                  <el-option label="教师" value="TEACHER" />
                </el-select>
              </el-form-item>
              <el-form-item prop="email">
                <el-input 
                  v-model="registerForm.email" 
                  placeholder="请输入邮箱（可选）"
                  size="large"
                  :prefix-icon="Message"
                  clearable
                />
              </el-form-item>
              <el-form-item prop="phone">
                <el-input 
                  v-model="registerForm.phone" 
                  placeholder="请输入电话（可选）"
                  size="large"
                  :prefix-icon="Phone"
                  clearable
                />
              </el-form-item>
              <el-form-item>
                <el-button 
                  type="primary" 
                  @click="handleRegister" 
                  class="login-button"
                  size="large"
                  :loading="registerLoading"
                >
                  注册
                </el-button>
              </el-form-item>
            </el-form>
          </el-tab-pane>
        </el-tabs>
      </el-card>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock, Avatar, Message, Phone, Document } from '@element-plus/icons-vue'
import { login, register } from '../api/user'
import { useUserStore } from '../stores/user'

// 导入背景图片 - 使用多种方式尝试
let bgImageUrl = ''

// 方法1: 使用 new URL (Vite 推荐方式)
try {
  const bgImage = new URL('../assets/images/login-bg.jpg', import.meta.url)
  bgImageUrl = bgImage.href
  console.log('========== 登录页面背景图片加载 ==========')
  console.log('方法1 (new URL) 成功')
  console.log('图片路径:', bgImageUrl)
} catch (error) {
  console.warn('方法1 (new URL) 失败:', error.message)
  
  // 方法2: 使用 import.meta.env.BASE_URL
  try {
    bgImageUrl = `${import.meta.env.BASE_URL}src/assets/images/login-bg.jpg`
    console.log('尝试方法2 (BASE_URL):', bgImageUrl)
  } catch (error2) {
    console.warn('方法2 失败:', error2.message)
    
    // 方法3: 使用相对路径
    bgImageUrl = '/src/assets/images/login-bg.jpg'
    console.log('使用方法3 (相对路径):', bgImageUrl)
  }
}

console.log('最终使用的图片URL:', bgImageUrl)

const router = useRouter()
const userStore = useUserStore()

const activeTab = ref('login')
const loginFormRef = ref()
const registerFormRef = ref()
const loginLoading = ref(false)
const registerLoading = ref(false)

const loginForm = ref({
  username: '',
  password: ''
})

const registerForm = ref({
  username: '',
  password: '',
  realName: '',
  role: 'STUDENT',
  email: '',
  phone: ''
})

const loginRules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}

const registerRules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
  realName: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  role: [{ required: true, message: '请选择角色', trigger: 'change' }]
}

const handleLogin = async () => {
  await loginFormRef.value.validate(async (valid) => {
    if (valid) {
      loginLoading.value = true
      try {
        const res = await login(loginForm.value)
        userStore.setUser(res.data)
        ElMessage.success('登录成功')
        router.push('/dashboard')
      } catch (error) {
        ElMessage.error(error.message || '登录失败')
      } finally {
        loginLoading.value = false
      }
    }
  })
}

const handleRegister = async () => {
  await registerFormRef.value.validate(async (valid) => {
    if (valid) {
      registerLoading.value = true
      try {
        await register(registerForm.value)
        ElMessage.success('注册成功，请登录')
        activeTab.value = 'login'
        loginForm.value.username = registerForm.value.username
      } catch (error) {
        ElMessage.error(error.message || '注册失败')
      } finally {
        registerLoading.value = false
      }
    }
  })
}

onMounted(() => {
  console.log('========== 登录页面挂载完成 ==========')
  console.log('背景图片URL:', bgImageUrl)
  
  // 检查背景元素是否存在
  const bgElement = document.querySelector('.login-background')
  if (bgElement) {
    console.log('背景元素找到:', bgElement)
    const computedStyle = window.getComputedStyle(bgElement)
    const bgImage = computedStyle.backgroundImage
    console.log('计算后的背景图片样式:', bgImage)
    
    if (!bgImage || bgImage === 'none') {
      console.warn('警告: 背景图片样式未应用')
    } else {
      console.log('背景图片样式已应用')
    }
  } else {
    console.error('错误: 未找到背景元素 .login-background')
  }
})
</script>

<style scoped>
.login-container {
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  width: 100%;
  overflow: hidden;
}

.login-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  filter: blur(1px);
  z-index: 0;
}

.login-background::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.3) 0%, rgba(118, 75, 162, 0.3) 100%);
  z-index: 1;
}

.login-wrapper {
  position: relative;
  z-index: 2;
  width: 100%;
  max-width: 450px;
  padding: 20px;
}

.login-card {
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
}

.login-card :deep(.el-card__header) {
  padding: 30px 20px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-bottom: none;
}

.login-header {
  text-align: center;
  color: white;
}

.logo-icon {
  margin-bottom: 15px;
  display: inline-block;
  padding: 15px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  backdrop-filter: blur(10px);
}

.login-title {
  margin: 0 0 8px 0;
  font-size: 28px;
  font-weight: 600;
  color: white;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.login-subtitle {
  margin: 0;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.9);
  font-weight: 300;
  letter-spacing: 1px;
}

.login-tabs {
  padding: 20px;
}

.login-tabs :deep(.el-tabs__header) {
  margin-bottom: 25px;
}

.login-tabs :deep(.el-tabs__item) {
  font-size: 16px;
  font-weight: 500;
  padding: 0 30px;
}

.login-tabs :deep(.el-tabs__active-bar) {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.login-tabs :deep(.el-tabs__item.is-active) {
  color: #667eea;
}

.login-form {
  padding: 0 10px;
}

.login-form :deep(.el-form-item) {
  margin-bottom: 20px;
}

.login-form :deep(.el-input__wrapper) {
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.login-form :deep(.el-input__wrapper:hover) {
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
}

.login-form :deep(.el-input.is-focus .el-input__wrapper) {
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
}

.login-form :deep(.el-select .el-input__wrapper) {
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.login-button {
  width: 100%;
  height: 48px;
  font-size: 16px;
  font-weight: 600;
  border-radius: 8px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
  transition: all 0.3s ease;
}

.login-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
}

.login-button:active {
  transform: translateY(0);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .login-wrapper {
    max-width: 100%;
    padding: 15px;
  }

  .login-card {
    border-radius: 12px;
  }

  .login-title {
    font-size: 24px;
  }

  .login-tabs :deep(.el-tabs__item) {
    padding: 0 20px;
    font-size: 14px;
  }
}

/* 动画效果 */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.login-card {
  animation: fadeIn 0.6s ease-out;
}
</style>
