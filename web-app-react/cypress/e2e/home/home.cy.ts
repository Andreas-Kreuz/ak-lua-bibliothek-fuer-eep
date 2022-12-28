import EepSimulator from '../../test-helpers/eep-simulator';

const simulator = new EepSimulator();

beforeEach(() => {
  simulator.reset();
});

describe('App Home', () => {
  it('contains Log and EEP-Web version after reset', () => {
    cy.visit('/');
    cy.contains('Log');
    cy.contains('Daten');
    cy.contains('EEP-Web:');
  });
  it('contains EEP-Web, EEP-Lua, and EEP version', () => {
    simulator.eepEvent('eep-version-complete.json');

    cy.visit('/');
    cy.contains('Log');
    cy.contains('Daten');
    cy.contains('EEP-Web: ');
    cy.contains('EEP-Lua: Lua 5.3');
    cy.contains('EEP: 17.0');
  });
});
