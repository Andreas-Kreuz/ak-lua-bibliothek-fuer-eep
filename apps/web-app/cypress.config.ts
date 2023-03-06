import { defineConfig } from 'cypress';

export default defineConfig({
  projectId: 'g5rj4e',
  e2e: {
    baseUrl: 'http://localhost:4173',
    testIsolation: false,
    setupNodeEvents(on, config) {
      // implement node event listeners here
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
