import { all } from 'cypress/types/bluebird';

const eepDir = 'cypress/io/LUA/ak/io/exchange/';
enum FileNames {
  eepOutJsonOut = 'cypress/io/LUA/ak/io/exchange/ak-eep-out.json',
  eepOutJsonOutFinished = 'cypress/io/LUA/ak/io/exchange/ak-eep-out-json.isfinished',
  eepOutLog = 'cypress/io/LUA/ak/io/exchange/ak-eep-out.log',
  serverOutCommands = 'cypress/io/LUA/ak/io/exchange/ak-eep-in.commands',
  serverWatching = 'cypress/io/LUA/ak/io/exchange/ak-server.iswatching',
}

export default class EepSimulator {
  fileNames = FileNames;
  eepDir = eepDir;
  private eventCounter = 0;
  private sim = this;

  logEventCounter = () => cy.log('Current Counter: ' + this.eventCounter.toString());

  reset = () => {
    this.eventCounter = 0;
    cy.readFile(FileNames.serverWatching).should('exist');
    cy.writeFile(FileNames.eepOutLog, '');
    cy.writeFile(FileNames.serverOutCommands, '');
    this.eepEvent('reset.json');
  };

  loadFixtures = (fixtures: string[]) => {
    const res = [];
    // could also use `res.push(f)` they should be equivalent
    fixtures.map((name, i) => cy.fixture(name).then((f) => (res[i] = f)));
    return cy.wrap(res);
  };

  simulateMap(mapName: string, startEvent: number, endEvent: number) {
    const eventFileNames = [];
    for (let i = startEvent; i <= endEvent; i++) {
      const name = mapName + '/eep-event' + i + '.json';
      eventFileNames.push(name);
    }
    const eventJsons = this.loadFixtures(eventFileNames).then((jsons) => {
      cy.log(jsons.length.toLocaleString());
      cy.writeFile(FileNames.serverOutCommands, '');
      this.writeNewEepEventFile(jsons.map((x) => JSON.stringify(x)).join('\n'));
    });
  }

  eepEvent(fileName: string) {
    this.eventCounter++;
    const count = this.eventCounter;
    cy.fixture('eep-output/' + fileName).then((x) => {
      x.eventCounter = count;
      cy.log(x.eventCounter, fileName, x);
      this.writeNewEepEventFile(JSON.stringify(x));
    });
  }

  writeLogLine(line: string) {
    cy.readFile(FileNames.eepOutLog, 'latin1').then((oldLines) => {
      cy.log(oldLines);
      cy.writeFile(FileNames.eepOutLog, oldLines + '\n' + line, 'latin1');
      cy.wait(100); // Give the web server some time to read new log lines
    });
  }

  private writeNewEepEventFile(eventLines: string) {
    cy.writeFile(FileNames.eepOutJsonOut, eventLines, 'latin1');
    cy.writeFile(FileNames.eepOutJsonOutFinished, '');
    cy.readFile(FileNames.eepOutJsonOutFinished).should('not.exist');
  }
}
