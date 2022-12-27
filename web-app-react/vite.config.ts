import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  optimizeDeps: {
    // We need to include all libraries manually
    include: ['web-shared'],
  },
  build: {
    commonjsOptions: {
      include: [
        'web-shared',
        'web-shared/data/model',
        'web-shared/model',
        'web-shared/rooms',
        '@mui/material',
        '@mui/icons-material',
      ],
    },
  },
});
