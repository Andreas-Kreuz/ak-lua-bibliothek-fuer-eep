import EepSimulator from '../../test-helpers/eep-simulator';
import { createScreenshots } from './createScreenshots';

describe('Intersections Screenshots', () => createScreenshots(tests));

function tests(size: string, simulator: EepSimulator) {
  function waitForHome() {
    simulator.simulateMap('map-01-events', 1, 81);
    cy.contains('App für EEP');
  }

  beforeEach(() => {
    simulator.reset();
  });
  describe('screenshot', () => {
    const path = `assets/doc/${size}-intersections`;
    it('/ intersections', () => {
      cy.visit('/simple/intersections');
      waitForHome();
      cy.contains('Kreuzung 2');
      cy.screenshot(`${path}`);
    });
    it('/ intersections', () => {
      cy.visit('/simple/intersection/1');
      waitForHome();
      cy.contains('Bahnhofstr.');
      cy.screenshot(`${path}-kreuzung1`);
    });
  });
}
