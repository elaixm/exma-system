import api from './index'

export const getExamList = (params) => api.get('/exams/list', { params })
export const getExamById = (id) => api.get(`/exams/${id}`)
export const createExam = (data) => api.post('/exams', data)
export const updateExam = (id, data) => api.put(`/exams/${id}`, data)
export const deleteExam = (id) => api.delete(`/exams/${id}`)
export const startExam = (id) => api.post(`/exams/${id}/start`)
export const getExamQuestions = (id) => api.get(`/exams/${id}/questions`)
export const saveAnswer = (id, answers) => api.post(`/exams/${id}/save-answer`, { answers })
export const submitExam = (id, answers) => api.post(`/exams/${id}/submit`, { answers })
export const getExamLogs = (id, studentId) => api.get(`/exams/${id}/logs`, { params: { studentId } })
export const getExamRecords = (id) => api.get(`/exams/${id}/records`)
export const getExamRecord = (examId, studentId) => {
  return api.get(`/exams/${examId}/records`, { params: { studentId } })
}

// 更新考试状态
export const updateExamStatus = (id, data) => api.put(`/exams/${id}/status`, data)

// 批量更新考试状态
export const batchUpdateExamStatus = (data) => api.put('/exams/batch-status', data)

// 触发自动更新考试状态
export const autoUpdateExamStatus = () => api.post('/exams/auto-update-status')

