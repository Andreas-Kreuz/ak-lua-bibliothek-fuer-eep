import fs from 'fs';
import path from 'path';
import readline from 'readline';
import { Tail } from 'tail';

const serverWatchingFile = 'ak-server.iswatching';
const serverReadyForJsonFile = 'ak-eep-out-json.isfinished';
const watchedJsonFileName = 'ak-eep-out.json';
const watchedLogFileName = 'ak-eep-out.log'; // TODO: CHANGE TO ak-eep-out.log
const writtenCommandFileName = 'ak-eep-in.commands';
const writtenEventFileName = 'ak-eep-in.event';

export default class FileOperations {
  private dir: string;
  private jsonFileWatcher: fs.FSWatcher;
  private logTail: Tail;
  private onJsonUpdate: (jsonText: string) => void;
  private onLogLine: (line: string) => void;

  constructor() {}

  public reInit(dir: string, callback: (err: string, dir: string) => void): void {
    this.dir = path.resolve(dir);

    if (this.logTail) {
      this.logTail.unwatch();
    }
    if (this.jsonFileWatcher) {
      this.jsonFileWatcher.close();
    }
    this.onJsonUpdate = (jsonText: string) => {
      console.log('Received: ' + jsonText.length + ' bytes of JSON');
    };
    this.onLogLine = (line: string) => {
      console.log(line);
    };

    fs.stat(this.dir, (err, stats) => {
      if (!err && stats.isDirectory()) {
        this.attachAkEepOutJsonFile();
        this.attachAkEepOutLogFile();
        this.createAkServerFile();
        callback(null, this.dir);
      } else {
        callback('No such directory: ' + this.dir, null);
      }
    });
  }

  private deleteFileIfExists(file: string): void {
    try {
      fs.unlinkSync(file);
    } catch (err) {
      /* ignored */
    }
  }

  private attachAkEepOutJsonFile(): void {
    const jsonFile = path.resolve(this.dir, watchedJsonFileName);
    const jsonReadyFile = path.resolve(this.dir, serverReadyForJsonFile);

    // First: delete the file from EEP, so EEP will know we are ready
    this.deleteFileIfExists(jsonReadyFile);

    // Watch in the directory, if the file is recreated
    this.jsonFileWatcher = fs.watch(this.dir, {}, (eventType: string, filename: string) => {
      // If the jsonReadyFile exists: Read the data and remove the file
      if (filename === serverReadyForJsonFile && fs.existsSync(jsonReadyFile)) {
        // EEP has written the JsonFile for us, so let's read it.
        fs.readFile(jsonFile, { encoding: 'latin1' }, (err, data) => {
          if (err) {
            console.log(err);
            this.deleteFileIfExists(jsonReadyFile);
          } else {
            this.onJsonUpdate(data);
          }
        });
        // Last: delete the file from EEP, so EEP will know we are ready
        this.deleteFileIfExists(jsonReadyFile);
      }
    });
  }

  private attachAkEepOutLogFile(): void {
    const logFile = path.resolve(this.dir, watchedLogFileName);
    this.oneFileAppearance(logFile, () => {
      const tail = new Tail(logFile, { encoding: 'latin1' });
      tail.on('line', (line: string) => this.onLogLine(line));

      tail.on('error', (error: string) => {
        console.log(error);
        tail.unwatch();
        this.attachAkEepOutLogFile();
      });
      this.logTail = tail;
    });
  }

  private oneFileAppearance(expectedFile: string, callback: () => void): void {
    if (fs.existsSync(expectedFile)) {
      callback();
    } else {
      console.log('[FILE] Wait for: ' + path.basename(expectedFile) + ' in ' + path.dirname(expectedFile));
      const watcher = fs.watch(path.dirname(expectedFile), {}, (eventType: string, filename: string) => {
        if (filename === path.basename(expectedFile) && fs.existsSync(expectedFile)) {
          console.log('[FILE] Found: ' + expectedFile);
          callback();
          watcher.close();
        }
      });
    }
  }

  public createAkServerFile() {
    const watchFile = path.resolve(this.dir, serverWatchingFile);
    // Create the serverWatchingFile
    fs.closeSync(fs.openSync(watchFile, 'w'));

    // Delete the file on exit
    process.on('exit', () => {
      fs.unlink(watchFile, (err) => {
        if (err) {
          throw err;
        }
        console.log('on(exit): ' + watchFile + ' successfully deleted');
      });
    });
  }

  public setOnJsonContentChanged(updateFunction: (jsonText: string) => void) {
    this.onJsonUpdate = updateFunction;
  }

  private setOnNewLogLine(logLineFunction: (line: string) => void) {
    this.onLogLine = logLineFunction;
  }
}
