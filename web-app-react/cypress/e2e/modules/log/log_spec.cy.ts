import EepSimulator from '../../../test-helpers/eep-simulator';

const simulator = new EepSimulator();

const getLogList = () => {
  cy.get('#open-log').click();
  return cy.get('ul');
};

beforeEach(() => {
  simulator.reset();
  cy.wait(1000); // Give the web server some time to remove the previous log lines
});

describe('Logger', () => {
  it('has no initial log', () => {
    cy.visit('/simple');
    cy.wait(500).then(() => {
      cy.readFile(simulator.fileNames.eepOutLog).then((a) => cy.log(a));
      getLogList().children().should('have.length', 0);
    });
  });

  describe('displays', () => {
    it('log line "Let us test something"', () => {
      simulator.writeLogLine('Let us test something');
      cy.visit('/simple');
      cy.wait(500).then(() => {
        cy.readFile(simulator.fileNames.eepOutLog).then((a) => cy.log(a));
        getLogList().children().should('have.length', 1).first().contains('Let us test something');
      });
    });

    it('latin1 characters correctly: "Äpfel, Überschuss, ÖPNV"', () => {
      simulator.writeLogLine('Äpfel, Überschuss, ÖPNV');
      cy.visit('/simple');
      cy.wait(500).then(() => {
        cy.readFile(simulator.fileNames.eepOutLog).then((a) => cy.log(a));
        getLogList().children().should('have.length', 1).first().contains('Äpfel, Überschuss, ÖPNV');
      });
    });

    it('displays log lines 1 to 3', () => {
      simulator.writeLogLine('Line 1\nLine 2\nLine 3');
      cy.visit('/simple');
      cy.wait(500).then(() => {
        cy.readFile(simulator.fileNames.eepOutLog).then((a) => cy.log(a));
        getLogList()
          .children()
          .should('have.length', 3)
          .first()
          .contains('Line 1')
          .next()
          .contains('Line 2')
          .next()
          .contains('Line 3');
      });
    });

    it('displays log lines 1 to 4', () => {
      simulator.writeLogLine('Line 1\nLine 2\nLine 3');
      simulator.writeLogLine('Line 4');
      cy.visit('/simple');
      cy.wait(500).then(() => {
        cy.readFile(simulator.fileNames.eepOutLog).then((a) => cy.log(a));
        getLogList()
          .children()
          .should('have.length', 4)
          .first()
          .contains('Line 1')
          .next()
          .contains('Line 2')
          .next()
          .contains('Line 3')
          .next()
          .contains('Line 4');
      });
    });
  });
  describe('action', () => {
    it('"Reset Button" sends "clearlog" command to EEP', () => {
      cy.writeFile(simulator.fileNames.serverOutCommands, '');
      cy.get('#delete-log').click();
      cy.readFile(simulator.fileNames.serverOutCommands, 'latin1').should('eq', 'clearlog\n');
    });
  });
});
