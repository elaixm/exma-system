import api from './index'

export const getScoresByExam = (examId) => api.get(`/scores/exam/${examId}`)
export const getScoresByStudent = (examId, studentId) => api.get(`/scores/exam/${examId}/student/${studentId}`)
export const updateSubjectiveScore = (id, data) => api.put(`/scores/${id}/grade`, data)
export const getKnowledgeGraph = (studentId) => api.get(`/scores/knowledge-graph/${studentId}`)
export const getClassWeakness = (examId) => api.get(`/scores/class-weakness/${examId}`)
export const getWrongBook = (params) => api.get('/scores/wrong-book', { params })
export const getExamScoreOverview = () => api.get('/scores/exam-overview')
export const getStudentExamDetail = (examId, studentId) => api.get(`/scores/exam/${examId}/student/${studentId}/detail`)

