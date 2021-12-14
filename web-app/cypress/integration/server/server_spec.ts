import EepSimulator from '../../test-helpers/eep-simulator';

const simulator = new EepSimulator();

beforeEach(() => {
  simulator.resetEvent();
});

// describe('Server Home ', () => {
//   it('shows api-entries on reset', () => {
//     cy.visit('/server');
//     cy.contains('Server');
//     cy.contains('Web App im Browser öffnen');
//     cy.contains('Happily Serving');
//     cy.contains('api-entries');
//   });
// });

describe('Server Home', () => {
  it('shows eep-version', () => {
    simulator.eepEvent('eep-version-complete.json');

    cy.visit('/');
    cy.visit('/server');
    cy.contains('Server');
    cy.contains('Web App im Browser öffnen');
    cy.contains('Happily Serving');
    cy.contains('api-entries');
    cy.contains('eep-version');
  });
});
