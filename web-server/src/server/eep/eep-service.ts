import fs from 'fs';
import path from 'path';
import readline from 'readline';
import { Tail } from 'tail';

const serverWatchingFile = 'ak-server.iswatching';
const serverReadyForJsonFile = 'ak-eep-out-json.isfinished';
const watchedJsonFileName = 'ak-eep-out.json';
const watchedLogFileName = 'ak-eep-out.log';
const writtenCommandFileName = 'ak-eep-in.commands';
const writtenEventFileName = 'ak-eep-in.event';

/**
 * This service is responsible for the communication with EEP.
 */
export default class EepService {
  private dir: string;
  private lastLogFileSize: number;
  private jsonFileWatcher: fs.FSWatcher;
  private logTail: Tail;
  private onJsonUpdate: (jsonText: string) => void;
  private logLineAppeared: (line: string) => void;
  private logWasCleared: () => void;

  constructor() {}

  reInit(dir: string, callback: (err: string, dir: string) => void): void {
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
    this.logLineAppeared = (line: string) => {
      console.log(line);
    };
    this.logWasCleared = () => {
      console.log('Log was cleared');
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
          // Delete the file from EEP, so EEP will know we are ready
          this.deleteFileIfExists(jsonReadyFile);
          if (err) {
            console.log(err);
          } else {
            this.onJsonUpdate(data);
          }
        });
      }
    });
  }

  private attachAkEepOutLogFile(): void {
    const logFile = path.resolve(this.dir, watchedLogFileName);
    this.oneFileAppearance(logFile, () => {
      const tail = new Tail(logFile, { encoding: 'latin1', fromBeginning: true });
      tail.on('line', (line: string) => {
        const stats = fs.statSync(logFile);
        const fileSizeInBytes = stats['size'];
        if (this.lastLogFileSize && fileSizeInBytes < this.lastLogFileSize) {
          this.logWasCleared(); // TODO: NOT WORKING; BECAUSE TAIL DOES NOT LOOK BACK
        }
        this.lastLogFileSize = fileSizeInBytes;
        this.logLineAppeared(line);
      });

      tail.on('error', (error: string) => {
        console.log(error);
        tail.unwatch();
        this.attachAkEepOutLogFile();
      });

      this.logTail = tail;
    });
  }

  getCurrentLogLines = (): string => {
    try {
      console.log('Read: ' + path.resolve(this.dir, watchedLogFileName));
      return fs.readFileSync(path.resolve(this.dir, watchedLogFileName), { encoding: 'latin1' });
    } catch (e) {
      console.log(e);
    }
    // tslint:disable-next-line: semicolon
  };

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

  public setOnNewLogLine(logLineFunction: (line: string) => void) {
    this.logLineAppeared = logLineFunction;
  }

  public setOnLogCleared(logClearedFunction: () => void) {
    this.logWasCleared = logClearedFunction;
  }

  queueCommand = (command: string) => {
    const file = path.resolve(this.dir, writtenCommandFileName);
    try {
      fs.appendFileSync(file, command + '\n', { encoding: 'latin1' });
    } catch (error) {
      console.log(error);
    }
    // tslint:disable-next-line: semicolon
  };
}
