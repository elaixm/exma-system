import api from './index'

export const getQuestionList = (params) => api.get('/questions/list', { params })
export const getQuestionById = (id) => api.get(`/questions/${id}`)
export const saveQuestion = (data) => api.post('/questions', data)
export const updateQuestion = (id, data) => api.put(`/questions/${id}`, data)
export const deleteQuestion = (id) => api.delete(`/questions/${id}`)
export const batchImport = (file) => {
  const formData = new FormData()
  formData.append('file', file)
  return api.post('/questions/batch-import', formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}
export const exportQuestions = () => api.get('/questions/export', { responseType: 'blob' })
export const getAllQuestions = () => api.get('/questions/all')

