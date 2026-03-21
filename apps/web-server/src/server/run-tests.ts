import * as fs from 'fs';
import * as path from 'path';

type RunnableTestModule = {
  run?: () => Promise<void>;
};

function findTestFiles(dir: string): string[] {
  const files: string[] = [];

  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...findTestFiles(fullPath));
      continue;
    }
    if (entry.isFile() && entry.name.endsWith('.test.js')) {
      files.push(fullPath);
    }
  }

  return files.sort((a, b) => a.localeCompare(b));
}

async function main(): Promise<void> {
  const serverBuildDir = __dirname;
  const testFiles = findTestFiles(serverBuildDir);

  if (testFiles.length === 0) {
    console.log('No server tests found.');
    return;
  }

  for (const testFile of testFiles) {
    const relativePath = path.relative(serverBuildDir, testFile);
    console.log('Running ' + relativePath);

    const testModule = require(testFile) as RunnableTestModule;
    if (typeof testModule.run !== 'function') {
      throw new Error('Server test does not export run(): ' + relativePath);
    }

    await testModule.run();
  }

  console.log('Executed ' + testFiles.length.toString() + ' server test file(s).');
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
