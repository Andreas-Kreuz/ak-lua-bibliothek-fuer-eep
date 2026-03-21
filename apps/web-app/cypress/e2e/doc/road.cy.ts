import EepSimulator from '../../test-helpers/eep-simulator';
import { createScreenshots } from './createScreenshots';

describe('Road Screenshots', () => createScreenshots(tests));

function tests(size: string, simulator: EepSimulator) {
  function waitForHome() {
    simulator.simulateMap('map-01-events', 1, 81);
    cy.contains('App für EEP');
  }

  beforeEach(() => {
    simulator.reset();
  });
  describe('screenshot', () => {
    const path = `assets/doc/${size}-road`;
    it('/ road', () => {
      cy.visit('/simple/road');
      waitForHome();
      cy.contains('Kreuzung 2');
      cy.screenshot(`${path}`);
    });
    it('/ road details', () => {
      cy.visit('/simple/road/1');
      waitForHome();
      cy.contains('Bahnhofstr.');
      cy.screenshot(`${path}-kreuzung1`);
    });
  });
}
