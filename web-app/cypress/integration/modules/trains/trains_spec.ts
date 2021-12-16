import EepSimulator from '../../../test-helpers/eep-simulator';

const simulator = new EepSimulator();

before(() => {
  simulator.simulateMap('map-01-events', 1, 81);
});

describe('Zugverbände Autos', () => {
  it('should contain mat-chip "Züge" to click on', () => {
    cy.visit('/trains/road');
    cy.get('mat-chip').contains('Züge').click();
    cy.url().should('include', '/trains/rail');
  });
});

describe('Zugverbände Züge', () => {
  it('should contain mat-chip "Autos" to click on', () => {
    cy.visit('/trains/rail');
    cy.get('mat-chip').contains('Autos').click();
    cy.url().should('include', '/trains/road');
  });
});
