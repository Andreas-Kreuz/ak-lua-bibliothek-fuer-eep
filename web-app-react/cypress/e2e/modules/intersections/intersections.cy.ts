import EepSimulator from '../../../test-helpers/eep-simulator';

const simulator = new EepSimulator();

before(() => {
  simulator.simulateMap('map-01-events', 1, 81);
});

describe('Intersections', () => {
  it('should contain an expand button which toggles the expansion', () => {
    cy.visit('/intersections');
    cy.contains('Bahnhofstr. - Hauptstr.');
    cy.contains('Kreuzung 2');
    cy.contains('Hilfe');
  });
});
