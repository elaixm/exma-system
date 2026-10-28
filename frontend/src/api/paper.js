import api from './index'

export const getPaperList = (params) => api.get('/papers/list', { params })
export const getPaperById = (id) => api.get(`/papers/${id}`)
export const savePaper = (data) => api.post('/papers', data)
export const updatePaper = (id, data) => api.put(`/papers/${id}`, data)
export const deletePaper = (id) => api.delete(`/papers/${id}`)
export const generateRandomPapers = (data) => api.post('/papers/generate-random', data)

