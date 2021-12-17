import EepSimulator from '../../../test-helpers/eep-simulator';

const simulator = new EepSimulator();

beforeEach(() => {
  simulator.reset();
  cy.wait(100); // Give the web server some time to remove the previous log lines
});

describe('Logger', () => {
  it('has no initial log', () => {
    cy.visit('/log');
    cy.get('ul.list-pre').children().should('have.length', 0);
  });

  describe('displays', () => {
    it('log line "Let us test something"', () => {
      simulator.writeLogLine('Let us test something');
      cy.visit('/log');
      cy.get('ul.list-pre').children().should('have.length', 1).first().contains('Let us test something');
    });

    it('latin1 characters correctly: "Äpfel, Überschuss, ÖPNV"', () => {
      simulator.writeLogLine('Äpfel, Überschuss, ÖPNV');
      cy.visit('/log');
      cy.get('ul.list-pre').children().should('have.length', 1).first().contains('Äpfel, Überschuss, ÖPNV');
    });

    it('displays log lines 1 to 3', () => {
      cy.wait(100);
      simulator.writeLogLine('Line 1\nLine 2\nLine 3');
      cy.visit('/log');
      cy.get('ul.list-pre')
        .children()
        .should('have.length', 3)
        .first()
        .contains('Line 1')
        .next()
        .contains('Line 2')
        .next()
        .contains('Line 3');
    });

    it('displays log lines 1 to 4', () => {
      simulator.writeLogLine('Line 1\nLine 2\nLine 3');
      simulator.writeLogLine('Line 4');
      cy.visit('/log');
      cy.get('ul.list-pre')
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
  describe('action', () => {
    it('"Reset Button" sends "clearlog" command to EEP', () => {
      cy.writeFile(simulator.fileNames.serverOutCommands, '');
      cy.get('#delete-log-button').click();
      cy.readFile(simulator.fileNames.serverOutCommands, 'latin1').should('eq', 'clearlog\n');
    });
  });
});
