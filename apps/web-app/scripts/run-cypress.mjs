import { spawn } from 'node:child_process';
import { resolve } from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';

const env = { ...process.env };
delete env.ELECTRON_RUN_AS_NODE;

const args = process.argv.slice(2);
const scriptDir = fileURLToPath(new URL('.', import.meta.url));
const cypressBin = resolve(scriptDir, '../../../node_modules/cypress/bin/cypress');

const child = spawn(process.execPath, [cypressBin, ...args], {
  cwd: process.cwd(),
  stdio: 'inherit',
  env,
});

child.on('exit', (code, signal) => {
  if (signal) {
    process.kill(process.pid, signal);
    return;
  }
  process.exit(code ?? 1);
});
