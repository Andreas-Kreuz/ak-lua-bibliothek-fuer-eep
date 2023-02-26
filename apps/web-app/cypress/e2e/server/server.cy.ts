import EepSimulator from '../../test-helpers/eep-simulator';

const simulator = new EepSimulator();

beforeEach(() => {
  simulator.reset();
});

describe('Server Home', () => {
  it('has 1 event and api-entries after reset', () => {
    cy.visit('/server');
    cy.contains('Server');
    cy.contains('App öffnen');
    cy.contains('Bereitgestellte Daten');
    cy.contains('aus 1 Events');
    cy.contains('api-entries');
  });

  it('has 2 events and contains eep-version after second event', () => {
    simulator.eepEvent('eep-version-complete.json');
    cy.visit('/server');
    cy.contains('aus 2 Events');
    cy.contains('api-entries');
    cy.contains('eep-version');
  });
});
