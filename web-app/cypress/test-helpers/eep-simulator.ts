enum FileNames {
  eepOutJsonOut = 'ak-eep-out.json',
  eepOutJsonOutFinished = 'ak-eep-out-json.isfinished',
  eepOutLog = 'ak-eep-out.log',
  eepInCommands = 'ak-eep-in.commands',
  serverWatching = 'ak-server.iswatching',
  serverCache = 'ak-eep-web-server-state.json',
  serverEventCounter = 'ak-eep-web-server-state.counter',
}

export default class EepSimulator {
  private eventCounter = 0;

  resetEvent = () => {
    this.eventCounter = 0;
    cy.readFile('cypress/io/' + FileNames.serverWatching).should('exist');
    cy.writeFile('cypress/io/' + FileNames.eepOutLog, '');
    this.eepEvent('reset.json');
  };

  eepEvent(fileName: string) {
    this.eventCounter++;
    cy.fixture('eep-output/' + fileName).then((x) => {
      x.eventCounter = this.eventCounter;
      console.log(x);
      cy.writeFile('cypress/io/' + FileNames.eepOutJsonOut, JSON.stringify(x), 'latin1');
      cy.writeFile('cypress/io/' + FileNames.eepOutJsonOutFinished, '');
      cy.readFile('cypress/io/' + FileNames.eepOutJsonOutFinished).should('not.exist');
    });
  }
}
