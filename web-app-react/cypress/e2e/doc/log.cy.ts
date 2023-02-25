import EepSimulator from '../../test-helpers/eep-simulator';
import { createScreenshots } from './createScreenshots';

export const screenShotsizes = [['ipad-2', 'landscape']];

describe('Log Screenshots', () => createScreenshots(tests, screenShotsizes));

function tests(size: string, simulator: EepSimulator) {
  function waitForHome() {
    simulator.eepEvent('eep-version-complete.json');
    cy.contains('App für EEP');
  }

  beforeEach(() => {});

  describe('screenshot', () => {
    const path = `assets/doc/${size}-home`;
    it('/ log open', () => {
      simulator.reset();
      simulator.writeLogLine('Willkommen in EEP');
      simulator.writeLogLine('-----------------');
      simulator.writeLogLine('EEPMain() wurde erfolgreich beendet');
      simulator.writeLogLine('Signal 3 geschaltet auf 2');
      simulator.writeLogLine('EEPMain() wurde erfolgreich beendet');
      simulator.writeLogLine('Signal 3 geschaltet auf 1');
      simulator.writeLogLine('EEPMain() wurde erfolgreich beendet');
      simulator.writeLogLine('Signal 3 geschaltet auf 2');
      simulator.writeLogLine('EEPMain() wurde erfolgreich beendet');
      simulator.writeLogLine('Signal 3 geschaltet auf 1');
      simulator.writeLogLine('EEPMain() wurde erfolgreich beendet');
      simulator.writeLogLine('Signal 3 geschaltet auf 2');
      simulator.writeLogLine('EEPMain() wurde erfolgreich beendet');
      simulator.writeLogLine('Signal 3 geschaltet auf 1');
      cy.visit('/simple/');
      waitForHome();
      cy.get('#open-log').click();
      simulator.writeLogLine('EEPMain() wurde erfolgreich beendet');
      simulator.writeLogLine('Signal 3 geschaltet auf 2');
      cy.wait(1000);
      cy.screenshot(`${path}-log`);
    });
    it('/ log closed', () => {
      cy.visit('/simple/');
      waitForHome();
      cy.screenshot(`${path}-log-closed`);
    });
  });
}
