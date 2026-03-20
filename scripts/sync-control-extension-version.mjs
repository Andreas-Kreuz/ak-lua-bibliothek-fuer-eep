import { readFileSync, writeFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const repoRoot = path.resolve(__dirname, '..');

function readJson(relativePath) {
  const absolutePath = path.join(repoRoot, relativePath);
  return JSON.parse(readFileSync(absolutePath, 'utf8'));
}

function writeJson(relativePath, value) {
  const absolutePath = path.join(repoRoot, relativePath);
  const content = `${JSON.stringify(value, null, 2)}\n`;
  writeFileSync(absolutePath, content, 'utf8');
}

function writeText(relativePath, value) {
  const absolutePath = path.join(repoRoot, relativePath);
  writeFileSync(absolutePath, `${value}\n`, 'utf8');
}

const rootPackage = readJson('package.json');
const version = rootPackage.version;

for (const relativePath of ['apps/web-app/package.json', 'apps/web-server/package.json']) {
  const packageJson = readJson(relativePath);
  if (packageJson.version !== version) {
    packageJson.version = version;
    writeJson(relativePath, packageJson);
  }
}

writeText('apps/web-app/VERSION', version);
writeText('lua/LUA/ce/VERSION', version);
