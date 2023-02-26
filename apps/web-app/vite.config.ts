import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import commonjs from '@rollup/plugin-commonjs';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react(), commonjs()],
  optimizeDeps: {
    // We need to include all libraries manually
    include: ['@ak/web-shared'],
    exclude: [],
  },
  build: {
    commonjsOptions: {
      include: ['@ak/web-shared'],
      exclude: [],
    },
  },
});
