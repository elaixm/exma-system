import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    port: 8931,
    proxy: {
      '/api': {
        target: 'http://localhost:8930',
        changeOrigin: true
      }
    }
  }
})

