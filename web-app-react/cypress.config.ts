import { defineConfig } from 'cypress';

export default defineConfig({
  projectId: 'g5rj4e',
  e2e: {
    baseUrl: 'http://localhost:5173',
    testIsolation: false,
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
});
