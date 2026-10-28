import api from './index'

export const getExamLogList = (params) => api.get('/exam-logs/list', { params })
export const getExamLogById = (id) => api.get(`/exam-logs/${id}`)
export const getLogStatistics = (params) => api.get('/exam-logs/statistics', { params })
export const logAction = (examId, action, detail) => api.post('/exam-logs/log-action', { examId, action, detail })

