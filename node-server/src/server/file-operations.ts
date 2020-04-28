import fs from 'fs';
import path from 'path';
import tail from 'tail';

const serverWatchingFile = 'ak-server.iswatching';
const serverReadyForJsonFile = 'ak-eep-out-json.isfinished';
const watchedJsonFileName = 'ak-eep-out.json';
const watchedLogFileName = 'ak-eep-out.socket'; // TODO: CHANGE TO ak-eep-out.log
const writtenCommandFileName = 'ak-eep-in.commands';
const writtenEventFileName = 'ak-eep-in.event';

export default class FileOperations {
  private jsonUpdate: (jsonText: string) => void;

  constructor(private dir = __dirname + '/../../../lua/LUA/ak/io/exchange/') {
    fs.watch(dir, {}, (eventType: string, filename: string) => {
      this.onFileChange(eventType, filename);
    });

    const fileToTail = dir + '/' + watchedLogFileName;
    const logTail = new tail.Tail(fileToTail, { fromBeginning: true, follow: true });
    logTail.on('line', (line: string) => this.onLogFileUpdated(line));

    const fileToTail2 = dir + '/' + watchedJsonFileName;
    const logTail2 = new tail.Tail(fileToTail2, { fromBeginning: true, follow: true, flushAtEOF: true });
    logTail2.on('line', (line: string) => this.onJsonFileUpdated(line));
    logTail2.on('error', (error: string) => console.log(error));

    fs.closeSync(fs.openSync(dir + '/' + serverWatchingFile, 'w'));
  }

  private onFileChange(eventType: string, filename: string) {
    if (filename) {
      switch (filename) {
        case watchedJsonFileName:
        case watchedLogFileName: {
          break;
        }
        default: {
          console.log(`Ignore file change <${eventType}> on: ${filename}`);
          break;
        }
      }
    } else {
      console.log('filename not provided');
    }
  }

  public onJsonContentChanged(updateFunction: (jsonText: string) => void) {
    this.jsonUpdate = updateFunction;
  }

  private onJsonFileUpdated(line: string) {
    // Inform the server
    console.log('JSON File updated!' + line.length);
    this.jsonUpdate(line);
    fs.unlinkSync(this.dir + '/' + serverReadyForJsonFile);
  }

  private onLogFileUpdated(line: string) {
    // Inform the server
    // console.log('Log File updated: ' + line);
  }
}
