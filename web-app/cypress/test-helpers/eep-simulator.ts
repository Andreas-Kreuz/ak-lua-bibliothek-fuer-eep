import { all } from 'cypress/types/bluebird';

enum FileNames {
  eepOutJsonOut = 'cypress/io/ak-eep-out.json',
  eepOutJsonOutFinished = 'cypress/io/ak-eep-out-json.isfinished',
  eepOutLog = 'cypress/io/ak-eep-out.log',
  serverOutCommands = 'cypress/io/ak-eep-in.commands',
  serverWatching = 'cypress/io/ak-server.iswatching',
}

export default class EepSimulator {
  private eventCounter = 0;

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
      this.writeNewEepEventFile(jsons.map((x) => JSON.stringify(x)).join('\n'));
    });
  }

  eepEvent(fileName: string) {
    this.eventCounter++;
    cy.fixture('eep-output/' + fileName).then((x) => {
      x.eventCounter = this.eventCounter;
      this.writeNewEepEventFile(JSON.stringify(x));
    });
  }

  private writeNewEepEventFile(eventLines: string) {
    cy.writeFile(FileNames.eepOutJsonOut, eventLines, 'latin1');
    cy.writeFile(FileNames.eepOutJsonOutFinished, '');
    cy.readFile(FileNames.eepOutJsonOutFinished).should('not.exist');
  }
}
