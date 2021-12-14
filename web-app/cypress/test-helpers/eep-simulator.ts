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

  eepEvent(fileName: string) {
    this.eventCounter++;
    cy.fixture('eep-output/' + fileName).then((x) => {
      x.eventCounter = this.eventCounter;
      console.log(x);
      cy.writeFile(FileNames.eepOutJsonOut, JSON.stringify(x), 'latin1');
      cy.writeFile(FileNames.eepOutJsonOutFinished, '');
      cy.readFile(FileNames.eepOutJsonOutFinished).should('not.exist');
    });
  }
}
