import EepSimulator from '../../../test-helpers/eep-simulator';

const simulator = new EepSimulator();

before(() => {
  simulator.reset();
});

describe('Logger', () => {
  it('has no initial log', () => {
    cy.visit('/log');
    cy.get('ul.list-pre').children().should('have.length', 0);
  });

  it('displays log line "Let us test something"', () => {
    simulator.reset();
    simulator.writeLogLine('Let us test something');
    cy.visit('/log');
    cy.get('ul.list-pre').children().should('have.length', 1).first().contains('Let us test something');
  });

  it('displays latin1 characters correctly: "Äpfel, Überschuss, ÖPNV"', () => {
    simulator.reset();
    simulator.writeLogLine('Äpfel, Überschuss, ÖPNV');
    cy.visit('/log');
    cy.get('ul.list-pre').children().should('have.length', 1).first().contains('Äpfel, Überschuss, ÖPNV');
  });

  it('displays log lines 1 to 3', () => {
    simulator.reset();
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
    // NO RESET BEFORE WRITING NEXT LINE
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

  it('sends reset command to EEP', () => {
    cy.writeFile(simulator.fileNames.serverOutCommands, '');
    cy.get('#delete-log-button').click();
    cy.readFile(simulator.fileNames.serverOutCommands, 'latin1').should('eq', 'clearlog\n');
  });
});
