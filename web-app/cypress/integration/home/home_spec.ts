import EepSimulator from '../../test-helpers/eep-simulator';

const simulator = new EepSimulator();

beforeEach(() => {
  simulator.resetEvent();
});

describe('Home Page without modules and no connection', () => {
  it('has the following entries', () => {
    cy.visit('/');
    cy.contains('Log');
    cy.contains('Daten');
    cy.contains('EEP-Web:');
  });
});

describe('Home Page without modules and version info', () => {
  it('has the following entries', () => {
    simulator.eepEvent('eep-version-complete.json');

    cy.visit('/');
    cy.contains('Log');
    cy.contains('Daten');
    cy.contains('EEP-Web:');
    cy.contains('EEP:');
    cy.contains('EEP:');
  });
});
