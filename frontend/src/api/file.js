import api from './index'

export const uploadFile = (file, folder = 'common') => {
  const formData = new FormData()
  formData.append('file', file)
  formData.append('folder', folder)
  return api.post('/files/upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

export const downloadFile = (path) => {
  return api.get('/files/download', { params: { path }, responseType: 'blob' })
}

export const viewFile = (path) => {
  return `/api/uploads${path}`
}

export const deleteFile = (path) => {
  return api.delete('/files/delete', { params: { path } })
}

