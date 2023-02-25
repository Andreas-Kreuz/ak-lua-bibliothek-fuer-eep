import EepSimulator from '../../test-helpers/eep-simulator';
import { createScreenshots } from './createScreenshots';

describe('Home Screenshots', () => createScreenshots(tests));

function tests(size: string, simulator: EepSimulator) {
  function waitForHome() {
    simulator.eepEvent('eep-version-complete.json');
    cy.contains('App für EEP');
  }

  beforeEach(() => {
    simulator.reset();
  });
  describe('screenshot', () => {
    const path = `assets/doc/${size}-home`;
    it('/ home', () => {
      cy.visit('/simple/');
      waitForHome();
      cy.contains('Lua 5.3');
      cy.screenshot(`${path}`);
    });
    it('/ home-eep-active', () => {
      cy.visit('/');
      waitForHome();
      cy.contains('EEP sendet Daten');
      cy.screenshot(`${path}eep-active`);
    });
    it('/ home-eep-paused', () => {
      cy.visit('/');
      waitForHome();
      cy.contains('EEP wurde pausiert');
      cy.screenshot(`${path}eep-paused`);
    });
  });
}
