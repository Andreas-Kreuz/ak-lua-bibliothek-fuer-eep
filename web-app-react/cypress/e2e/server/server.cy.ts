import EepSimulator from '../../test-helpers/eep-simulator';

const simulator = new EepSimulator();

beforeEach(() => {
  simulator.reset();
});

describe('Server Home', () => {
  it('has 1 event and api-entries after reset', () => {
    cy.visit('/server');
    cy.contains('Server');
    cy.contains('Web-App im Browser öffnen');
    cy.contains('Happily Serving');
    cy.contains('(1 events)');
    cy.contains('api-entries');
  });

  it('has 2 events and contains eep-version after second event', () => {
    simulator.eepEvent('eep-version-complete.json');
    cy.visit('/server');
    cy.contains('(2 events)');
    cy.contains('api-entries');
    cy.contains('eep-version');
  });
});
