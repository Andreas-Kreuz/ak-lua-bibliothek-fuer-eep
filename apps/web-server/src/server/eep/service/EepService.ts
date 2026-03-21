import { CacheService } from '../server-data/CacheService';
import { FileNames } from './FileNames';
import { LogFileMonitor } from './LogFileMonitor';
import { ServerStatisticsService } from './ServerStatisticsService';
import * as fs from 'fs';
import * as path from 'path';
import { performance } from 'perf_hooks';
import { Tail } from 'tail';

/**
 * This service is responsible for the communication with EEP.
 */
export default class EepService implements CacheService {
  private dir: string;
  private jsonFileWatcher: fs.FSWatcher;
  private readonly logFileMonitor: LogFileMonitor;
  private eventTail: Tail;
  private onJsonUpdate: (jsonText: string, lastUpdate: number) => void;
  private logLineAppeared: (line: string) => void;
  private eventLineAppeared: (line: string) => void;
  private logWasCleared: () => void;

  constructor(private debug = false) {
    this.logFileMonitor = new LogFileMonitor(
      {
        onCleared: () => this.logWasCleared(),
        onLinesAppeared: (lines) => this.logLineAppeared(lines),
      },
      debug,
    );
  }

  reInit(dir: string, callback: (err: string, dir: string) => void): void {
    this.disconnectFromFiles();

    this.dir = path.resolve(dir);
    fs.stat(this.dir, (err, stats) => {
      if (!err && stats.isDirectory()) {
        callback(null, this.dir);
        this.connectToFiles();
      } else {
        callback('No such directory: ' + this.dir, null);
      }
    });
  }

  disconnect(): void {
    this.disconnectFromFiles();
  }

  private connectToFiles(): void {
    this.attachEventsFromCeFile();
    this.attachLogFromCeFile();
    this.createServerIsRunningFile();
    this.deleteFileOnExit(FileNames.serverEventCounter);
  }

  private disconnectFromFiles(): void {
    if (this.dir) {
      this.deleteFileIfExists(path.resolve(this.dir, FileNames.serverIsRunning));
    }

    this.logFileMonitor.detach();
    if (this.eventTail) {
      this.eventTail.unwatch();
    }
    if (this.jsonFileWatcher) {
      this.jsonFileWatcher.close();
    }
    this.onJsonUpdate = (jsonText: string, lastUpdate: number) => {
      if (this.debug) console.log('Received: ' + jsonText.length + ' bytes of JSON ' + lastUpdate);
    };
    this.eventLineAppeared = (_line) => {
      if (this.debug) console.log(_line);
    };
    this.logLineAppeared = (_line: string) => {};
    this.logWasCleared = () => {
      if (this.debug) console.log('Log was cleared');
    };
  }

  public readCache(): unknown {
    try {
      const cacheFile = path.resolve(this.dir, FileNames.serverCache);
      const fileContents = fs.readFileSync(cacheFile);
      const cachedObject = JSON.parse(fileContents.toString());
      if (this.debug) console.log('CACHE FILE READ FROM: ' + FileNames.serverCache);
      return cachedObject;
    } catch (_err) {
      console.log(_err);
      return null;
    }
  }

  public writeCache(data: unknown): void {
    const d = data as { eventCounter?: number };
    performance.mark('eep:start-write-cache-file');
    try {
      if (data) {
        const cacheFile = path.resolve(this.dir, FileNames.serverCache);
        const fileContents = JSON.stringify(data);
        fs.writeFileSync(cacheFile, fileContents);

        if (d.eventCounter) {
          const counterFile = path.resolve(this.dir, FileNames.serverEventCounter);
          fs.writeFileSync(counterFile, d.eventCounter.toString(10));
        }
      }
    } catch (_err) {
      console.log(_err);
    }
    performance.mark('eep:stop-write-cache-file');
    performance.measure(
      ServerStatisticsService.TimeForEepJsonFile,
      'eep:start-write-cache-file',
      'eep:stop-write-cache-file'
    );
  }

  private deleteFileIfExists(file: string): void {
    try {
      fs.unlinkSync(file);
    } catch (_err) {
      // IGNORED - console.log(err);
    }
  }

  private attachEventsFromCeFile(): void {
    const jsonFile = path.resolve(this.dir, FileNames.eventsFromCe);
    const jsonReadyFile = path.resolve(this.dir, FileNames.eventsFromCePending);

    // First start: Read the JSON file - ignore if EEP is ready
    if (!this.jsonFileWatcher) {
      performance.mark('eep:start-wait-for-json');
      this.readJsonFile(jsonFile, jsonReadyFile);
    }

    // First start: Delete the EEP FINISHED file, so EEP will know we are ready
    this.deleteFileIfExists(jsonReadyFile);

    // Watch in the directory, if the file is recreated
    this.jsonFileWatcher = fs.watch(this.dir, {}, (eventType: string, filename: string) => {
      // If the jsonReadyFile exists: Read the data and remove the file
      if (filename === FileNames.eventsFromCePending && fs.existsSync(jsonReadyFile)) {
        // console.log('Reading: ', jsonFile);
        this.readJsonFile(jsonFile, jsonReadyFile);
      }
    });
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

  private attachLogFromCeFile(): void {
    this.logFileMonitor.attach(path.resolve(this.dir, FileNames.logFromCe));
  }

  getCurrentLogLines = (): string => {
    return this.logFileMonitor.readCurrentLogLines();
  }

  public createServerIsRunningFile() {
    const watchFile = path.resolve(this.dir, FileNames.serverIsRunning);
    // Create the server-is-running marker file
    fs.closeSync(fs.openSync(watchFile, 'w'));
    this.deleteFileOnExit(FileNames.serverIsRunning);
  }

  private deleteFileOnExit(fileName: string) {
    // Delete the event counter file on exit
    const file = path.resolve(this.dir, fileName);
    process.on('exit', () => {
      fs.unlink(file, (err) => {
        if (err) {
          console.error(err);
        }
        if (this.debug) console.log('on(exit): ' + file + ' successfully deleted');
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
    const file = path.resolve(this.dir, FileNames.commandsToCe);
    try {
      if (this.debug) console.log('Queuing: ' + command);
      fs.appendFileSync(file, command + '\n', { encoding: 'latin1' });
    } catch (error) {
      console.log(error);
    }
    // tslint:disable-next-line: semicolon
  };
}
