import fs from 'fs';
import path from 'path';
import readline from 'readline';

const serverWatchingFile = 'ak-server.iswatching';
const serverReadyForJsonFile = 'ak-eep-out-json.isfinished';
const watchedJsonFileName = 'ak-eep-out.json';
const watchedLogFileName = 'ak-eep-out.socket'; // TODO: CHANGE TO ak-eep-out.log
const writtenCommandFileName = 'ak-eep-in.commands';
const writtenEventFileName = 'ak-eep-in.event';

export default class FileOperations {
  private onJsonUpdate = (jsonText: string) => {
    console.log('Received: ' + jsonText.length + ' bytes of JSON');
  }
  private onLogLine = (line: string) => {};

  constructor(private dir: string) {
    this.dir = path.resolve(dir);

    this.attachAkEepOutJsonFile(dir);
    this.attachAkEepOutLogFile(dir);
    this.createAkServerFile(dir);
  }

  private deleteFileIfExists(file: string): void {
    try {
      fs.unlinkSync(file);
    } catch (err) {
      /* ignored */
    }
  }

  private attachAkEepOutJsonFile(dir: string): void {
    const jsonFile = path.resolve(dir, watchedJsonFileName);
    const jsonReadyFile = path.resolve(dir, serverReadyForJsonFile);

    this.deleteFileIfExists(jsonReadyFile);
    fs.watch(dir, {}, (eventType: string, filename: string) => {
      // If the jsonReadyFile exists: Read the data and remove the file
      if (filename === serverReadyForJsonFile && fs.existsSync(jsonReadyFile)) {
        fs.readFile(jsonFile, { encoding: 'latin1' }, (err, data) => {
          if (err) {
            console.log(err);
          }
          this.onJsonUpdate(data);
        });
        this.deleteFileIfExists(jsonReadyFile);
      }
    });
  }

  private attachAkEepOutLogFile(dir: string): void {
    const logFile = path.resolve(dir, watchedLogFileName);
    const logFileStream = fs.createReadStream(logFile, { encoding: 'latin1' });

    const rl = readline.createInterface({
      input: logFileStream,
      crlfDelay: Infinity,
    });

    rl.on('line', (line) => this.onLogLine(line));

    process.on('exit', () => {
      rl.close();
      console.log('on(exit): ' + logFile + ' stream closed.');
    });
  }

  public createAkServerFile(dir: string) {
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
