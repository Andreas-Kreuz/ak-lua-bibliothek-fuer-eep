import { defineConfig } from 'cypress';
import { rm } from 'node:fs';

export default defineConfig({
  projectId: 'g5rj4e',
  e2e: {
    baseUrl: 'http://localhost:3000',
    testIsolation: false,
    setupNodeEvents(on) {
      on('task', {
        deleteEepLogFile(fileName) {
          rm(fileName, () => {});
          return null;
        },
      });
    },
  },
  component: {
    devServer: {
      framework: 'react',
      bundler: 'vite',
    },
  },
  env: {
    production: true,
  },
});
