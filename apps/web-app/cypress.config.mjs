import { defineConfig } from 'cypress';
import { rm } from 'node:fs';
import { access } from 'node:fs/promises';

async function waitForFileMissing(fileName, timeoutMs = 5000) {
  const start = Date.now();

  while (Date.now() - start < timeoutMs) {
    try {
      await access(fileName);
    } catch (error) {
      if (error && typeof error === 'object' && 'code' in error && error.code === 'ENOENT') {
        return true;
      }
    }

    await new Promise((resolve) => setTimeout(resolve, 50));
  }

  throw new Error(`Timed out waiting for file to disappear: ${fileName}`);
}

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
        waitForFileMissing(fileName) {
          return waitForFileMissing(fileName);
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
