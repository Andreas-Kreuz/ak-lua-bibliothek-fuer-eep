import { spawn } from 'node:child_process';
import process from 'node:process';

const appDir = process.cwd();
const baseUrl = 'http://127.0.0.1:3000';
const probeUrls = [`${baseUrl}/server`, `${baseUrl}/api/v1/api-stats`, `${baseUrl}/api/v1/api-entries`];

const wait = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function waitForHttp(url, timeoutMs = 30000) {
  const started = Date.now();
  while (Date.now() - started < timeoutMs) {
    try {
      const response = await fetch(url);
      if (response.ok) {
        return;
      }
    } catch {
      // Server not ready yet.
    }
    await wait(500);
  }

  throw new Error(`Timed out waiting for ${url}`);
}

function terminate(child) {
  if (!child.killed) {
    child.kill('SIGTERM');
  }
}

const server = spawn('yarn', ['run', 'start-server-headless'], {
  cwd: appDir,
  stdio: 'inherit',
  shell: process.platform === 'win32',
});

try {
  for (const url of probeUrls) {
    await waitForHttp(url);
  }
  console.log('Headless smoke test passed for app and server.');
} catch (error) {
  terminate(server);
  throw error;
}

terminate(server);
