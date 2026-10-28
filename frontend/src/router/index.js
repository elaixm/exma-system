import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '../stores/user'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue'),
    meta: { requiresAuth: false }
  },
  {
    path: '/',
    component: () => import('../layouts/MainLayout.vue'),
    redirect: '/dashboard',
    meta: { requiresAuth: true },
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('../views/Dashboard.vue')
      },
      {
        path: 'users',
        name: 'Users',
        component: () => import('../views/Users.vue'),
        meta: { roles: ['ADMIN'] }
      },
      {
        path: 'questions',
        name: 'Questions',
        component: () => import('../views/Questions.vue'),
        meta: { roles: ['ADMIN', 'TEACHER'] }
      },
      {
        path: 'papers',
        name: 'Papers',
        component: () => import('../views/Papers.vue'),
        meta: { roles: ['ADMIN', 'TEACHER'] }
      },
      {
        path: 'exams',
        name: 'Exams',
        component: () => import('../views/Exams.vue')
      },
      {
        path: 'exam/:id',
        name: 'Exam',
        component: () => import('../views/Exam.vue'),
        meta: { roles: ['STUDENT'] }
      },
      {
        path: 'scores',
        name: 'Scores',
        component: () => import('../views/Scores.vue')
      },
      {
        path: 'knowledge-graph',
        name: 'KnowledgeGraph',
        component: () => import('../views/KnowledgeGraph.vue'),
        meta: { roles: ['STUDENT'] }
      },
      {
        path: 'wrong-book',
        name: 'WrongBook',
        component: () => import('../views/WrongBook.vue'),
        meta: { roles: ['STUDENT'] }
      },
      {
        path: 'exam-logs',
        name: 'ExamLogs',
        component: () => import('../views/ExamLogs.vue'),
        meta: { roles: ['ADMIN', 'TEACHER'] }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const userStore = useUserStore()
  const token = localStorage.getItem('token')
  
  if (to.meta.requiresAuth && !token) {
    next('/login')
  } else if (to.meta.roles && token) {
    const userRole = userStore.role
    if (!to.meta.roles.includes(userRole)) {
      next('/dashboard')
    } else {
      next()
    }
  } else {
    next()
  }
})

export default router

