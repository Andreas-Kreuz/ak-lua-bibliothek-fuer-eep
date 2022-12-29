import EepSimulator from '../../test-helpers/eep-simulator';

const simulator = new EepSimulator();
const DIRECTORY = 'ANOTHER_DIRECTORY';

describe('Server Tests "/server"', () => {
  const pwd: { dir: string } = { dir: '-' };

  before(() => {
    // Remember the old server dir otherwise the following tests will not work!
    cy.visit('/server');
    cy.wait(500).then(() => {
      cy.get('#choose-dir-current-dir')
        .should('not.have.text', '-')
        .should('not.contain.text', 'io-empty')
        .invoke('text')
        .then((value) => {
          pwd.dir = value as string;
        });
    });
    simulator.reset();
    simulator.eepEvent('eep-version-complete.json');
    cy.wait(500).then(() => {
      cy.contains('api-entries');
      cy.contains('eep-version');
      cy.contains('aus 2 Events');
    });
  });

  after(() => {
    if (pwd.dir) {
      // Reset the old server dir otherwise the following tests will not work!
      cy.log('RESET TO: ' + pwd.dir);
      cy.visit('/server');
      cy.wait(500);
      cy.get('#choose-dir-current-dir')
        .should('not.have.text', '-')
        .then(() => {
          cy.get('#choose-dir-button')
            .should('be.enabled')
            .click()
            .then(() => {
              cy.get('input#dir-dialog-dir')
                .should('exist')
                .should('be.visible')
                .wait(100)
                .clear()
                .type(pwd.dir)
                .then((bla) => {
                  cy.get('#dir-dialog-choose').click().should('not.exist');
                });
            });
        });
    }
  });

  it('has button "Ordner wählen"', () => {
    cy.get('#choose-dir-button');
  });
  it('contains "Bereitgestellte Daten"', () => {
    cy.contains('Bereitgestellte Daten');
  });
  it('contains "(2 Events)"', () => {
    cy.contains('aus 2 Events');
  });

  describe('Changing the directory', () => {
    it('button "Wählen" is enabled', () => {
      cy.get('#choose-dir-button').click();
      cy.get('input#dir-dialog-dir').should('be.visible').should('contain.value', pwd.dir);
      cy.get('#dir-dialog-choose').should('be.enabled');
      cy.get('#dir-dialog-cancel').should('be.enabled');
      cy.get('#dir-dialog-cancel').should('be.enabled').click().should('not.exist');
    });
    it('button "Wählen" is disabled', () => {
      cy.get('#choose-dir-button').click();
      cy.get('input#dir-dialog-dir')
        .should('be.visible')
        .should('contain.value', 'io')
        .wait(100)
        .clear()
        .type('{selectall}{backspace}')
        .then(() => {
          cy.get('#dir-dialog-choose')
            .should('be.disabled')
            .then(() => {
              cy.get('#dir-dialog-cancel').should('be.enabled');
              cy.get('#dir-dialog-cancel').should('be.enabled').click().should('not.exist');
            });
        });
    });
    describe('Changing to "bad" directory', () => {
      it('Change to non-existing directory error', () => {
        cy.get('#choose-dir-button')
          .should('be.enabled')
          .click()
          .then(() => {
            cy.get('input#dir-dialog-dir')
              .wait(100)
              .clear()
              .type('non-existing')
              .then(() => {
                cy.get('#dir-dialog-choose').click().should('not.exist');
                cy.wait(1000);
                cy.contains('Bevor es losgeht, muss Du nur noch den Ordner von EEP angeben.');
              });
          });
      });

      it('Change to EEP directory without contents ', () => {
        cy.get('#choose-dir-button')
          .should('be.enabled')
          .click()
          .then(() => {
            cy.get('input#dir-dialog-dir')
              .should('exist')
              .should('be.visible')
              .wait(100)
              .clear()
              .type(pwd.dir + '-empty')
              .then(() => {
                cy.get('#dir-dialog-choose').click().should('not.exist');
                cy.wait(1000);
                cy.contains('Es wurden keine Daten von EEP gesammelt');
              });
          });
      });

      after(() => {
        // Reset the old server dir otherwise the following tests will not work!
        cy.get('#choose-dir-current-dir')
          .should('contain.text', '-empty')
          .then(() => {
            cy.get('#choose-dir-button')
              .should('be.enabled')
              .click()
              .then(() => {
                cy.get('input#dir-dialog-dir')
                  .should('exist')
                  .should('be.visible')
                  .wait(100)
                  .clear()
                  .type(pwd.dir)
                  .then(() => {
                    cy.get('#dir-dialog-choose').click().should('not.exist');
                  });
              });
          });
      });
    });
  });
});
