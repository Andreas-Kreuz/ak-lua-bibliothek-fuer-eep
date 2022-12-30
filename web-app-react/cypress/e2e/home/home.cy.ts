import EepSimulator from '../../test-helpers/eep-simulator';

const simulator = new EepSimulator();

beforeEach(() => {
  simulator.reset();
});

describe('App Home', () => {
  it('contains Log and EEP-Web version after reset', () => {
    cy.visit('/');
    cy.contains('App für EEP');
    cy.contains('Log');
    cy.contains('Daten');
  });
  it('contains App, EEP and Lua version', () => {
    simulator.eepEvent('eep-version-complete.json');

    cy.visit('/');
    cy.contains('Log');
    cy.contains('Daten');
    cy.contains('App ');
    cy.contains('Lua 5.3');
    cy.contains('EEP 17.0');
  });
});
