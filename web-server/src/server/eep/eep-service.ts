import fs from 'fs';
import path from 'path';
import { performance } from 'perf_hooks';
import { Tail } from 'tail';
import { ServerStatisticsService } from '../app/app-statistics.service';

const serverWatchingFile = 'ak-server.iswatching';
const serverReadyForJsonFile = 'ak-eep-out-json.isfinished';
const watchedJsonFileName = 'ak-eep-out.json';
const watchedLogFileName = 'ak-eep-out.log';
const writtenCommandFileName = 'ak-eep-in.commands';
const writtenEventFileName = 'ak-eep-out.eventlog';

/**
 * This service is responsible for the communication with EEP.
 */
export default class EepService {
  private dir: string;
  private lastLogFileSize: number;
  private lastEventFileSize: number;
  private jsonFileWatcher: fs.FSWatcher;
  private logTail: Tail;
  private eventTail: Tail;
  private onJsonUpdate: (jsonText: string, lastUpdate: number) => void;
  private logLineAppeared: (line: string) => void;
  private eventLineAppeared: (line: string) => void;
  private logWasCleared: () => void;
  private lastJsonUpdate: number;

  reInit(dir: string, callback: (err: string, dir: string) => void): void {
    this.dir = path.resolve(dir);

    if (this.logTail) {
      this.logTail.unwatch();
    }
    if (this.eventTail) {
      this.eventTail.unwatch();
    }
    if (this.jsonFileWatcher) {
      this.jsonFileWatcher.close();
    }
    this.onJsonUpdate = (jsonText: string, lastUpdate: number) => {
      console.log('Received: ' + jsonText.length + ' bytes of JSON ' + lastUpdate);
    };
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    this.eventLineAppeared = (line: string) => {
      //console.log(line);
    };
    this.logLineAppeared = (line: string) => {
      console.log(line);
    };
    this.logWasCleared = () => {
      console.log('Log was cleared');
    };

    fs.stat(this.dir, (err, stats) => {
      if (!err && stats.isDirectory()) {
        callback(null, this.dir);
        this.attachAkEepOutJsonFile();
        this.attachAkEepOutLogFile();
        this.attachAkEepOutEventFile();
        this.createAkServerFile();
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

    // First start: Read the JSON file - ignore if EEP is ready
    if (!this.jsonFileWatcher) {
      this.readJsonFile(jsonFile, jsonReadyFile);
    }

    // First start: Delete the EEP FINISHED file, so EEP will know we are ready
    this.deleteFileIfExists(jsonReadyFile);
    performance.mark('eep:start-wait-for-json');

    // Watch in the directory, if the file is recreated
    this.jsonFileWatcher = fs.watch(this.dir, {}, (eventType: string, filename: string) => {
      // If the jsonReadyFile exists: Read the data and remove the file
      if (filename === serverReadyForJsonFile && fs.existsSync(jsonReadyFile)) {
        this.lastJsonUpdate = performance.now();
        this.readJsonFile(jsonFile, jsonReadyFile);
      }
    });
  }

  private readJsonFile(jsonFile: string, jsonReadyFile: string) {
    try {
      // EEP has written the JsonFile for us, so let's read it.
      const data = fs.readFileSync(jsonFile, { encoding: 'latin1' });
      performance.mark('eep:stop-wait-for-json');
      performance.measure(
        ServerStatisticsService.TimeForEepJsonFile,
        'eep:start-wait-for-json',
        'eep:stop-wait-for-json'
      );

      // Delete the EEP FINISHED file, so EEP will know we are ready
      this.deleteFileIfExists(jsonReadyFile);
      performance.mark('eep:start-wait-for-json');

      this.onJsonUpdate(data, this.lastJsonUpdate);
    } catch (err) {
      console.log(err);
    }
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

  private attachAkEepOutEventFile(): void {
    const logFile = path.resolve(this.dir, writtenEventFileName);
    this.oneFileAppearance(logFile, () => {
      const tail = new Tail(logFile, { encoding: 'latin1', fromBeginning: true });
      tail.on('line', (line: string) => {
        const stats = fs.statSync(logFile);
        const fileSizeInBytes = stats['size'];
        if (this.lastEventFileSize && fileSizeInBytes < this.lastEventFileSize) {
          this.logWasCleared(); // TODO: NOT WORKING; BECAUSE TAIL DOES NOT LOOK BACK
        }
        this.lastEventFileSize = fileSizeInBytes;
        this.eventLineAppeared(line);
      });

      tail.on('error', (error: string) => {
        console.log(error);
        tail.unwatch();
        this.attachAkEepOutEventFile();
      });

      this.eventTail = tail;
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

  public setOnJsonContentChanged(updateFunction: (jsonText: string, lastUpdate: number) => void) {
    this.onJsonUpdate = updateFunction;
  }

  public setOnNewLogLine(logLineFunction: (line: string) => void) {
    this.logLineAppeared = logLineFunction;
  }

  public setOnNewEventLine(eventLineFunction: (line: string) => void) {
    this.eventLineAppeared = eventLineFunction;
  }

  public setOnLogCleared(logClearedFunction: () => void) {
    this.logWasCleared = logClearedFunction;
  }

  queueCommand = (command: string) => {
    const file = path.resolve(this.dir, writtenCommandFileName);
    try {
      console.log('Queuing: ' + command);
      fs.appendFileSync(file, command + '\n', { encoding: 'latin1' });
    } catch (error) {
      console.log(error);
    }
    // tslint:disable-next-line: semicolon
  };
}
