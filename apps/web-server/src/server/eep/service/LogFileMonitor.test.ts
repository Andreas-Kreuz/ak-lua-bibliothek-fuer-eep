import * as assert from 'node:assert/strict';
import { appendFile, mkdtemp, rename, rm, unlink, writeFile } from 'node:fs/promises';
import * as os from 'node:os';
import * as path from 'node:path';
import { setTimeout as delay } from 'node:timers/promises';
import { LogFileMonitor } from './LogFileMonitor';

const logFileName = 'log-from-ce';
const resetMarker = '@@CE_LOG_RESET@@';

async function waitFor(check: () => void, timeoutMs = 2000): Promise<void> {
  const end = Date.now() + timeoutMs;
  let lastError: unknown;

  while (Date.now() < end) {
    try {
      check();
      return;
    } catch (error) {
      lastError = error;
      await delay(25);
    }
  }

  throw lastError instanceof Error ? lastError : new Error('Condition was not met in time.');
}

async function luaRestart(logFilePath: string, content = ''): Promise<void> {
  await writeFile(logFilePath, content, { encoding: 'latin1' });
}

async function luaReset(logFilePath: string): Promise<void> {
  await appendFile(logFilePath, resetMarker + '\n', { encoding: 'latin1' });
}

async function luaPrint(logFilePath: string, ...args: string[]): Promise<void> {
  let text = '12:34:56 ';
  for (const arg of args) {
    text += arg.replace(/\n/g, '\n       . ');
  }
  await appendFile(logFilePath, text + '\n', { encoding: 'latin1' });
}

async function runTest(name: string, fn: () => Promise<void>): Promise<void> {
  try {
    await fn();
    console.log('ok - ' + name);
  } catch (error) {
    console.error('not ok - ' + name);
    throw error;
  }
}

async function withMonitor(
  runCase: (ctx: {
    logFilePath: string;
    seenBatches: string[];
    getSeenClears: () => number;
    monitor: LogFileMonitor;
  }) => Promise<void>,
  beforeAttach?: (ctx: { logFilePath: string }) => Promise<void>,
): Promise<void> {
  const tempDir = await mkdtemp(path.join(os.tmpdir(), 'log-file-monitor-'));
  const logFilePath = path.join(tempDir, logFileName);
  const seenBatches: string[] = [];
  let seenClears = 0;
  const monitor = new LogFileMonitor(
    {
      onCleared: () => {
        seenClears++;
      },
      onLinesAppeared: (lines) => seenBatches.push(lines),
    },
    false,
    20,
  );

  try {
    if (beforeAttach) {
      await beforeAttach({ logFilePath });
    }
    monitor.attach(logFilePath);
    await runCase({
      logFilePath,
      seenBatches,
      getSeenClears: () => seenClears,
      monitor,
    });
  } finally {
    monitor.detach();
    await rm(tempDir, { recursive: true, force: true });
  }
}

async function testInitialEmptyLogAndLuaStyleAppends(): Promise<void> {
  await withMonitor(
    async ({ logFilePath, seenBatches, getSeenClears, monitor }) => {
      await delay(80);

      assert.equal(getSeenClears(), 0);
      assert.equal(seenBatches.length, 0);
      assert.equal(monitor.readCurrentLogLines(), '');

      await luaPrint(logFilePath, 'Alpha');
      await waitFor(() => {
        assert.equal(seenBatches.length, 1);
        assert.equal(seenBatches[0], '12:34:56 Alpha');
      });

      await delay(120);
      assert.equal(seenBatches.length, 1);
      assert.equal(monitor.readCurrentLogLines(), '12:34:56 Alpha');

      await luaPrint(logFilePath, 'Bravo\nCharlie');
      await waitFor(() => {
        assert.equal(seenBatches.length, 2);
        assert.equal(seenBatches[1], '12:34:56 Bravo\n       . Charlie');
      });

      assert.ok(seenBatches.every((batch) => !batch.includes('\n\n')));
      assert.equal(
        monitor.readCurrentLogLines(),
        '12:34:56 Alpha\n12:34:56 Bravo\n       . Charlie',
      );
    },
    async ({ logFilePath }) => {
      await luaRestart(logFilePath);
    },
  );
}

async function testStartupUsesOnlyLinesAfterLastResetMarker(): Promise<void> {
  await withMonitor(
    async ({ seenBatches, getSeenClears, monitor }) => {
      await waitFor(() => {
        assert.equal(seenBatches.length, 1);
        assert.equal(seenBatches[0], '12:34:56 Existing after latest reset');
      });

      assert.equal(getSeenClears(), 0);
      assert.equal(monitor.readCurrentLogLines(), '12:34:56 Existing after latest reset');
    },
    async ({ logFilePath }) => {
      await luaRestart(
        logFilePath,
        [
          '12:34:56 Before first reset',
          resetMarker,
          '12:34:56 Before second reset',
          resetMarker,
          '12:34:56 Existing after latest reset',
          '',
        ].join('\n'),
      );
    },
  );
}

async function testRuntimeResetMarkerClearsVisibleLog(): Promise<void> {
  await withMonitor(
    async ({ logFilePath, seenBatches, getSeenClears, monitor }) => {
      await luaPrint(logFilePath, 'Short');
      await waitFor(() => {
        assert.equal(seenBatches.length, 1);
        assert.equal(seenBatches[0], '12:34:56 Short');
      });

      await luaReset(logFilePath);
      await waitFor(() => {
        assert.equal(getSeenClears(), 1);
        assert.equal(monitor.readCurrentLogLines(), '');
      });

      await luaPrint(logFilePath, 'This line is intentionally much longer than before');
      await waitFor(() => {
        assert.equal(seenBatches.length, 2);
        assert.equal(seenBatches[1], '12:34:56 This line is intentionally much longer than before');
        assert.equal(monitor.readCurrentLogLines(), '12:34:56 This line is intentionally much longer than before');
      });
    },
    async ({ logFilePath }) => {
      await luaRestart(logFilePath);
    },
  );
}

async function testShrinkRereadsFromStartAndUsesLastResetMarker(): Promise<void> {
  await withMonitor(
    async ({ logFilePath, seenBatches, getSeenClears, monitor }) => {
      await luaPrint(logFilePath, 'This line is intentionally much longer than the restart output');
      await waitFor(() => {
        assert.equal(seenBatches.length, 1);
      });

      await luaRestart(
        logFilePath,
        [
          '12:34:56 Old restart noise',
          resetMarker,
          '12:34:56 After restart',
          '',
        ].join('\n'),
      );

      await waitFor(() => {
        assert.equal(getSeenClears(), 1);
        assert.equal(seenBatches.length, 2);
        assert.equal(seenBatches[1], '12:34:56 After restart');
        assert.equal(monitor.readCurrentLogLines(), '12:34:56 After restart');
      });
    },
    async ({ logFilePath }) => {
      await luaRestart(logFilePath);
    },
  );
}

async function testRecreatedFileRebuildsVisibleState(): Promise<void> {
  await withMonitor(
    async ({ logFilePath, seenBatches, monitor }) => {
      await luaPrint(logFilePath, 'First');
      await waitFor(() => {
        assert.equal(seenBatches.length, 1);
        assert.equal(seenBatches[0], '12:34:56 First');
      });

      const missingLogPath = logFilePath + '.missing';
      await rename(logFilePath, missingLogPath);
      await delay(120);

      assert.equal(seenBatches.length, 1);

      await luaRestart(logFilePath, '12:34:56 First\n12:34:56 Second\n');
      await unlink(missingLogPath);
      await waitFor(() => {
        assert.equal(seenBatches.length, 2);
        assert.equal(seenBatches[1], '12:34:56 First\n12:34:56 Second');
        assert.equal(monitor.readCurrentLogLines(), '12:34:56 First\n12:34:56 Second');
      });
    },
    async ({ logFilePath }) => {
      await luaRestart(logFilePath);
    },
  );
}

export async function run(): Promise<void> {
  await runTest('LogFileMonitor reads lua-style log appends without duplicates', testInitialEmptyLogAndLuaStyleAppends);
  await runTest('LogFileMonitor startup uses only lines after the last reset marker', testStartupUsesOnlyLinesAfterLastResetMarker);
  await runTest('LogFileMonitor clears the visible log when the reset marker appears', testRuntimeResetMarkerClearsVisibleLog);
  await runTest('LogFileMonitor resets after file shrink and rereads from the last reset marker', testShrinkRereadsFromStartAndUsesLastResetMarker);
  await runTest('LogFileMonitor rebuilds the visible state when the log file disappears and later reappears', testRecreatedFileRebuildsVisibleState);
}

if (require.main === module) {
  run().catch((error) => {
    console.error(error);
    process.exit(1);
  });
}
