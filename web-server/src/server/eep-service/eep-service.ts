import fs from 'fs';
import path from 'path';
import { performance } from 'perf_hooks';
import { Tail } from 'tail';
import { ServerStatisticsService } from '../app/app-statistics.service';
import { CacheService } from './cache-service';

export enum FileNames {
  eepOutJsonOut = 'ak-eep-out.json',
  eepOutJsonOutFinished = 'ak-eep-out-json.isfinished',
  eepOutLog = 'ak-eep-out.log',
  serverOutCommands = 'ak-eep-in.commands',
  serverWatching = 'ak-server.iswatching',
  serverCache = 'ak-eep-web-server-state.json',
  serverEventCounter = 'ak-eep-web-server-state.counter',
}

/**
 * This service is responsible for the communication with EEP.
 */
export default class EepService implements CacheService {
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
        this.createAkServerFile();
        this.deleteFileOnExit(FileNames.serverEventCounter);
      } else {
        callback('No such directory: ' + this.dir, null);
      }
    });
  }

  private deleteFileIfExists(file: string): void {
    try {
      fs.unlinkSync(file);
    } catch (err) {
      // IGNORED - console.log(err);
    }
  }

  private attachAkEepOutJsonFile(): void {
    const jsonFile = path.resolve(this.dir, FileNames.eepOutJsonOut);
    const jsonReadyFile = path.resolve(this.dir, FileNames.eepOutJsonOutFinished);

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
      if (filename === FileNames.eepOutJsonOutFinished && fs.existsSync(jsonReadyFile)) {
        this.lastJsonUpdate = performance.now();
        // console.log('Reading: ', jsonFile);
        this.readJsonFile(jsonFile, jsonReadyFile);
      }
    });
  }

  public readCache(): undefined {
    try {
      const cacheFile = path.resolve(this.dir, FileNames.serverCache);
      const fileContents = fs.readFileSync(cacheFile);
      const cachedObject = JSON.parse(fileContents.toString());
      console.log('CACHE FILE READ FROM: ' + FileNames.serverCache);
      return cachedObject;
    } catch (err) {
      console.log(err);
      return null;
    }
  }

  public writeCache(data: { eventCounter: number }): void {
    performance.mark('eep:start-write-cache-file');
    try {
      if (data) {
        const cacheFile = path.resolve(this.dir, FileNames.serverCache);
        const fileContents = JSON.stringify(data);
        fs.writeFileSync(cacheFile, fileContents);

        if (data.eventCounter) {
          const counterFile = path.resolve(this.dir, FileNames.serverEventCounter);
          fs.writeFileSync(counterFile, data.eventCounter);
        }
      }
    } catch (err) {
      console.log(err);
    }
    performance.mark('eep:stop-write-cache-file');
    performance.measure(
      ServerStatisticsService.TimeForEepJsonFile,
      'eep:start-write-cache-file',
      'eep:stop-write-cache-file'
    );
  }

  private readJsonFile(jsonFile: string, jsonReadyFile: string) {
    try {
      // EEP has written the JsonFile for us, so let's read it.
      const data: string = fs.readFileSync(jsonFile, { encoding: 'latin1' });
      const eventLines: string[] = data.split('\n');
      for (const line of eventLines) {
        if (line.length > 0) {
          this.eventLineAppeared(line);
        }
      }

      performance.mark('eep:stop-wait-for-json');
      performance.measure(
        ServerStatisticsService.TimeForEepJsonFile,
        'eep:start-wait-for-json',
        'eep:stop-wait-for-json'
      );

      // Delete the EEP FINISHED file, so EEP will know we are ready
      this.deleteFileIfExists(jsonReadyFile);
      performance.mark('eep:start-wait-for-json');
    } catch (err) {
      console.log(err);
    }
  }

  private attachAkEepOutLogFile(): void {
    const logFile = path.resolve(this.dir, FileNames.eepOutLog);
    this.onFileAppearance(logFile, () => {
      const tail = new Tail(logFile, { encoding: 'latin1', fromBeginning: true });
      tail.on('line', (line: string) => {
        const stats = fs.statSync(logFile);
        const fileSizeInBytes = stats['size'];
        if (this.lastLogFileSize && fileSizeInBytes < this.lastLogFileSize) {
          this.logWasCleared(); // TODO: NOT WORKING; BECAUSE TAIL DOES NOT LOOK BACK
          tail.unwatch();
          this.lastLogFileSize = 0;
          setTimeout(() => this.attachAkEepOutLogFile(), 150);
        }
        this.lastLogFileSize = fileSizeInBytes;
        this.logLineAppeared(line);
      });

      tail.on('error', (error: string) => {
        console.log(error);
        tail.unwatch();
        this.lastLogFileSize = 0;
        this.attachAkEepOutLogFile();
      });

      this.logTail = tail;
    });
  }

  getCurrentLogLines = (): string => {
    try {
      console.log('Read: ' + path.resolve(this.dir, FileNames.eepOutLog));
      return fs.readFileSync(path.resolve(this.dir, FileNames.eepOutLog), { encoding: 'latin1' });
    } catch (e) {
      console.log(e);
    }
    // tslint:disable-next-line: semicolon
  };

  private onFileAppearance(expectedFile: string, callback: () => void): void {
    if (fs.existsSync(expectedFile)) {
      console.log('[FILE] Found: ' + expectedFile);
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
    const watchFile = path.resolve(this.dir, FileNames.serverWatching);
    // Create the serverWatchingFile
    fs.closeSync(fs.openSync(watchFile, 'w'));
    this.deleteFileOnExit(FileNames.serverWatching);
  }

  private deleteFileOnExit(fileName: string) {
    // Delete the event counter file on exit
    const file = path.resolve(this.dir, fileName);
    process.on('exit', () => {
      fs.unlink(file, (err) => {
        if (err) {
          console.error(err);
        }
        console.log('on(exit): ' + file + ' successfully deleted');
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
    const file = path.resolve(this.dir, FileNames.serverOutCommands);
    try {
      console.log('Queuing: ' + command);
      fs.appendFileSync(file, command + '\n', { encoding: 'latin1' });
    } catch (error) {
      console.log(error);
    }
    // tslint:disable-next-line: semicolon
  };
}
