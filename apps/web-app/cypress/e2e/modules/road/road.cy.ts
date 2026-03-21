import EepSimulator from '../../../test-helpers/eep-simulator';

const simulator = new EepSimulator();

before(() => {
  simulator.simulateMap('map-01-events', 1, 81);
});

describe('Road', () => {
  it('should contain an expand button which toggles the expansion', () => {
    cy.visit('/simple/road');
    cy.contains('Bahnhofstr. - Hauptstr.');
    cy.contains('Kreuzung 2');
    cy.contains('Hilfe');
  });
});
