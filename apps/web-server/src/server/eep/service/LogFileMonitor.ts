import * as fs from 'fs';
import * as path from 'path';

type LogFileMonitorCallbacks = {
  onCleared: () => void;
  onLinesAppeared: (lines: string) => void;
};

const resetMarker = '@@CE_LOG_RESET@@';

export class LogFileMonitor {
  private logFileWatcher: fs.FSWatcher;
  private pollTimer: NodeJS.Timeout;
  private logFilePath: string;
  private readOffset = 0;
  private pendingFragment = '';
  private currentLogLines = '';
  private initialScanCompleted = false;
  private suppressResetCallbackOnce = false;

  constructor(
    private callbacks: LogFileMonitorCallbacks,
    private debug = false,
    private pollIntervalMs = 200,
  ) {}

  public attach(logFilePath: string): void {
    this.detach();

    this.logFilePath = logFilePath;
    this.logFileWatcher = fs.watch(path.dirname(this.logFilePath), {}, () => {
      this.reconcile();
    });
    this.pollTimer = setInterval(() => this.reconcile(), this.pollIntervalMs);
    this.reconcile();
  }

  public detach(): void {
    if (this.pollTimer) {
      clearInterval(this.pollTimer);
      this.pollTimer = null;
    }
    if (this.logFileWatcher) {
      this.logFileWatcher.close();
      this.logFileWatcher = null;
    }

    this.logFilePath = null;
    this.readOffset = 0;
    this.pendingFragment = '';
    this.currentLogLines = '';
    this.initialScanCompleted = false;
    this.suppressResetCallbackOnce = false;
  }

  public readCurrentLogLines(): string {
    return this.currentLogLines;
  }

  private reconcile(): void {
    if (!this.logFilePath) {
      return;
    }

    const logFileSize = this.readLogFileSize();
    if (logFileSize === null) {
      return;
    }

    const fileShrank = logFileSize < this.readOffset;
    if (fileShrank) {
      if (this.initialScanCompleted) {
        if (this.debug) console.log('[FILE] Reset log stream after shrink:', this.logFilePath);
        this.callbacks.onCleared();
      }
      this.readOffset = 0;
      this.pendingFragment = '';
      this.currentLogLines = '';
      this.suppressResetCallbackOnce = true;
    }

    if (logFileSize <= this.readOffset) {
      this.initialScanCompleted = true;
      return;
    }

    try {
      const { content, bytesRead } = this.readRange(this.readOffset, logFileSize - this.readOffset);
      this.readOffset += bytesRead;
      this.processContent(content, !this.initialScanCompleted || this.suppressResetCallbackOnce);
      this.initialScanCompleted = true;
      this.suppressResetCallbackOnce = false;
    } catch (error) {
      if (this.debug) console.log(error);
    }
  }

  private readLogFileSize(): number | null {
    try {
      return fs.statSync(this.logFilePath).size;
    } catch (_error) {
      return null;
    }
  }

  private readRange(offset: number, length: number): { content: string; bytesRead: number } {
    const fd = fs.openSync(this.logFilePath, 'r');
    try {
      const buffer = Buffer.alloc(length);
      const bytesRead = fs.readSync(fd, buffer, 0, length, offset);
      return {
        content: buffer.subarray(0, bytesRead).toString('latin1'),
        bytesRead,
      };
    } finally {
      fs.closeSync(fd);
    }
  }

  private processContent(content: string, suppressResetCallback: boolean): void {
    if (!content) {
      return;
    }

    const combined = this.pendingFragment + content;
    const fragments = combined.split('\n');
    const hasTrailingNewline = combined.endsWith('\n');
    const completeLines = hasTrailingNewline ? fragments : fragments.slice(0, -1);

    this.pendingFragment = hasTrailingNewline ? '' : (fragments[fragments.length - 1] ?? '');

    let visibleLines: string[] = [];
    for (const fragment of completeLines) {
      const line = fragment.endsWith('\r') ? fragment.slice(0, -1) : fragment;
      if (line.trim().length === 0) {
        continue;
      }
      if (line === resetMarker) {
        this.currentLogLines = '';
        visibleLines = [];
        if (!suppressResetCallback) {
          this.callbacks.onCleared();
        }
        continue;
      }

      visibleLines.push(line);
    }

    if (visibleLines.length === 0) {
      return;
    }

    const newLines = visibleLines.join('\n');
    this.currentLogLines = this.currentLogLines.length > 0
      ? this.currentLogLines + '\n' + newLines
      : newLines;
    this.callbacks.onLinesAppeared(newLines);
  }
}
