import { defineStore } from 'pinia'
import { ref } from 'vue'
import api from '../api'

export const useUserStore = defineStore('user', () => {
  const token = ref(localStorage.getItem('token') || '')
  const username = ref(localStorage.getItem('username') || '')
  const role = ref(localStorage.getItem('role') || '')
  const realName = ref(localStorage.getItem('realName') || '')

  function setUser(userData) {
    token.value = userData.token
    username.value = userData.username
    role.value = userData.role
    realName.value = userData.realName
    localStorage.setItem('token', userData.token)
    localStorage.setItem('username', userData.username)
    localStorage.setItem('role', userData.role)
    localStorage.setItem('realName', userData.realName)
  }

  function logout() {
    token.value = ''
    username.value = ''
    role.value = ''
    realName.value = ''
    localStorage.removeItem('token')
    localStorage.removeItem('username')
    localStorage.removeItem('role')
    localStorage.removeItem('realName')
  }

  return {
    token,
    username,
    role,
    realName,
    setUser,
    logout
  }
})

