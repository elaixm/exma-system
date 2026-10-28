import api from './index'

export const login = (data) => api.post('/auth/login', data)
export const register = (data) => api.post('/auth/register', data)
export const getUserList = (params) => api.get('/users/list', { params })
export const getUserById = (id) => api.get(`/users/${id}`)
export const getCurrentUser = () => api.get('/users/current')
export const createUser = (data) => api.post('/users', data)
export const updateUser = (id, data) => api.put(`/users/${id}`, data)
export const deleteUser = (id) => api.delete(`/users/${id}`)

