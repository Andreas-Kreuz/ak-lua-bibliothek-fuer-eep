import { version } from '../../package.json';

export enum FileNames {
  eventsFromCe = 'cypress/io/LUA/ce/databridge/exchange/events-from-ce',
  eventsFromCePending = 'cypress/io/LUA/ce/databridge/exchange/events-from-ce.pending',
  logFromCe = 'cypress/io/LUA/ce/databridge/exchange/log-from-ce',
  commandsToCe = 'cypress/io/LUA/ce/databridge/exchange/commands-to-ce',
  serverIsRunning = 'cypress/io/LUA/ce/databridge/exchange/server-is-running',
}

const resetMarker = '@@CE_LOG_RESET@@';

export default class EepSimulator {
  private eventCounter = 0;
  fileNames = FileNames;

  logEventCounter = () => cy.log('Current Counter: ' + this.eventCounter.toString());

  reset = () => {
    this.eventCounter = 0;
    cy.task('deleteEepLogFile', FileNames.logFromCe);
    cy.readFile(FileNames.logFromCe).should('not.exist');
    cy.readFile(FileNames.serverIsRunning).should('exist');
    cy.writeFile(FileNames.logFromCe, '', 'latin1');
    cy.writeFile(FileNames.commandsToCe, '');
    this.eepEvent('reset.json');
  };

  loadFixtures = (fixtures: string[]): Cypress.Chainable<any[]> => {
    const res: any[] = [];
    // could also use `res.push(f)` they should be equivalent
    fixtures.map((name, i) => cy.fixture(name).then((f) => (res[i] = f)));
    return cy.wrap<any[]>(res);
  };

  simulateMap(mapName: string, startEvent: number, endEvent: number) {
    const eventFileNames = [];
    for (let i = startEvent; i <= endEvent; i++) {
      const name = mapName + '/eep-event' + i + '.json';
      eventFileNames.push(name);
    }
    const eventJsons = this.loadFixtures(eventFileNames).then((jsons) => {
      cy.log(jsons.length.toLocaleString());
      cy.writeFile(FileNames.commandsToCe, '');
      this.writeNewEepEventFile(jsons.map((x) => JSON.stringify(x)).join('\n'));
    });
  }

  eepEvent(fileName: string, replacements?: any) {
    this.eventCounter++;
    const count = this.eventCounter;
    cy.fixture('eep-output/' + fileName).then((x) => {
      x.eventCounter = count;
      if (x?.payload?.list?.versionInfo?.singleVersion) {
        x.payload.list.versionInfo.singleVersion = version;
      }
      cy.log(x.eventCounter, fileName, x);
      this.writeNewEepEventFile(JSON.stringify(x));
    });
  }

  // Append complete log lines like LogOutputFileWriter does.
  writeLogLine(line: string) {
    cy.readFile(FileNames.logFromCe, 'latin1').then((oldLines) => {
      cy.log(oldLines);
      const prefix = oldLines.length > 0 && !oldLines.endsWith('\n') ? oldLines + '\n' : oldLines;
      cy.writeFile(FileNames.logFromCe, prefix + line + '\n', 'latin1');
      cy.wait(100); // Give the web server some time to read new log lines
    });
  }

  appendLogResetMarker() {
    this.writeLogLine(resetMarker);
  }

  private writeNewEepEventFile(eventLines: string) {
    cy.writeFile(FileNames.eventsFromCe, eventLines, 'latin1');
    cy.writeFile(FileNames.eventsFromCePending, '');
    cy.task('waitForFileMissing', FileNames.eventsFromCePending);
  }
}
