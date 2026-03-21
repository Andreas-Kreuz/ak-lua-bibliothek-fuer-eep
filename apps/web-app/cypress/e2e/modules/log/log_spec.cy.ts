import EepSimulator from '../../../test-helpers/eep-simulator';

const simulator = new EepSimulator();

const getLogList = () => {
  cy.get('#open-log').then(($button) => {
    if ($button.text().includes('Log anzeigen')) {
      cy.wrap($button).click();
    }
  });
  return cy.get('ul');
};

before(() => {
  simulator.reset();
});

beforeEach(() => {
  simulator.reset();
  cy.wait(500); // Give the web server some time to remove the previous log lines
});

afterEach(() => {
  cy.wait(500);
});

describe('Logger', () => {
  it('has no initial log', () => {
    cy.visit('/');
    cy.wait(500).then(() => {
      cy.readFile(simulator.fileNames.logFromCe).then((a) => cy.log(a));
      getLogList().children().should('have.length', 0);
    });
  });

  describe('displays', () => {
    it('log line "Let us test something"', () => {
      simulator.writeLogLine('Let us test something');
      cy.visit('/');
      cy.wait(500).then(() => {
        cy.readFile(simulator.fileNames.logFromCe).then((a) => cy.log(a));
        getLogList().children().should('have.length', 1).first().contains('Let us test something');
      });
    });

    it('latin1 characters correctly: "Äpfel, Überschuss, ÖPNV"', () => {
      simulator.writeLogLine('Äpfel, Überschuss, ÖPNV');
      cy.visit('/');
      cy.wait(500).then(() => {
        cy.readFile(simulator.fileNames.logFromCe).then((a) => cy.log(a));
        getLogList().children().should('have.length', 1).first().contains('Äpfel, Überschuss, ÖPNV');
      });
    });

    it('displays log lines 1 to 3', () => {
      simulator.writeLogLine('Line 1\nLine 2\nLine 3');
      cy.visit('/');
      cy.wait(500).then(() => {
        cy.readFile(simulator.fileNames.logFromCe).then((a) => cy.log(a));
        getLogList()
          .children()
          .should('have.length', 3)
          .first()
          .contains('Line 1')
          .next()
          .contains('Line 2')
          .next()
          .contains('Line 3');
      });
    });

    it('displays log lines 1 to 4', () => {
      simulator.writeLogLine('Line 1\nLine 2\nLine 3\nLine 4');
      cy.visit('/');
      cy.wait(500).then(() => {
        cy.readFile(simulator.fileNames.logFromCe).then((a) => cy.log(a));
        getLogList()
          .children()
          .should('have.length', 4)
          .first()
          .contains('Line 1')
          .next()
          .contains('Line 2')
          .next()
          .contains('Line 3')
          .next()
          .contains('Line 4');
      });
    });
  });
  describe('action', () => {
    it('"Reset Button" sends "clearlog" command to EEP', () => {
      cy.writeFile(simulator.fileNames.commandsToCe, '');
      cy.visit('/');
      cy.wait(500).then(() => {
        cy.get('#open-log').click();
        cy.get('#delete-log').click();
      });
      cy.readFile(simulator.fileNames.commandsToCe, 'latin1').should('eq', 'clearlog\n');
    });
  });

  describe('reset marker', () => {
    it('clears the visible log when @@CE_LOG_RESET@@ is appended at runtime', () => {
      simulator.writeLogLine('Before reset');
      cy.visit('/');
      cy.wait(500).then(() => {
        getLogList().children().should('have.length', 1).first().contains('Before reset');
      });

      simulator.appendLogResetMarker();
      cy.wait(500).then(() => {
        getLogList().children().should('have.length', 0);
      });

      simulator.writeLogLine('After reset');
      cy.wait(500).then(() => {
        getLogList().children().should('have.length', 1).first().contains('After reset');
      });
    });
  });
});
