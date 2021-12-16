import EepSimulator from '../../../test-helpers/eep-simulator';

const simulator = new EepSimulator();

before(() => {
  simulator.simulateMap('map-01-events', 1, 81);
});

describe('Trains generally', () => {
  it('should contain an expand button which toggles the expansion', () => {
    cy.visit('/trains/road');
    cy.get('#expand-btn0').contains('expand_more').click();
    cy.get('#expand-btn0').contains('expand_less').click();
  });

  describe('have a cam button', () => {
    it('click 1 on cam will change to rolling stock camera', () => {
      cy.visit('/trains/road');
      cy.get('#expand-btn0').contains('expand_more').click();
      cy.get('#cam-btn0').contains('videocam').click();
      cy.readFile(simulator.fileNames.serverOutCommands, 'latin1').should(
        'eq',
        'EEPRollingstockSetActive|6MGT Wagen 1 DVBAG\nEEPRollingstockSetUserCamera|6MGT Wagen 1 DVBAG|14.55|-3|5|15|80\n'
      );
    });
    it('click 2 on cam will change to perspective 3', () => {
      cy.writeFile(simulator.fileNames.serverOutCommands, '');
      cy.get('#cam-btn0').contains('videocam').click();
      cy.readFile(simulator.fileNames.serverOutCommands, 'latin1').should(
        'eq',
        'EEPSetPerspectiveCamera|3|#6MGT Wagen 1 DVBAG;001\n'
      );
    });
    it('click 3 on cam will change to perspective 4', () => {
      cy.writeFile(simulator.fileNames.serverOutCommands, '');
      cy.get('#cam-btn0').contains('videocam').click();
      cy.readFile(simulator.fileNames.serverOutCommands, 'latin1').should(
        'eq',
        'EEPSetPerspectiveCamera|4|#6MGT Wagen 1 DVBAG;001\n'
      );
    });
    it('click 4 on cam will change to perspective 10', () => {
      cy.writeFile(simulator.fileNames.serverOutCommands, '');
      cy.get('#cam-btn0').contains('videocam').click();
      cy.readFile(simulator.fileNames.serverOutCommands, 'latin1').should(
        'eq',
        'EEPSetPerspectiveCamera|10|#6MGT Wagen 1 DVBAG;001\n'
      );
    });
    it('click 5 on cam will change to perspective 9', () => {
      cy.writeFile(simulator.fileNames.serverOutCommands, '');
      cy.get('#cam-btn0').contains('videocam').click();
      cy.readFile(simulator.fileNames.serverOutCommands, 'latin1').should(
        'eq',
        'EEPSetPerspectiveCamera|9|#6MGT Wagen 1 DVBAG;001\n'
      );
    });
    it('click 6 on cam will back to rollingstock camera', () => {
      cy.writeFile(simulator.fileNames.serverOutCommands, '');
      cy.get('#cam-btn0').contains('videocam').click();
      cy.readFile(simulator.fileNames.serverOutCommands, 'latin1').should(
        'eq',
        'EEPRollingstockSetActive|6MGT Wagen 1 DVBAG\nEEPRollingstockSetUserCamera|6MGT Wagen 1 DVBAG|14.55|-3|5|15|80\n'
      );
    });
  });

  describe('have navigation chips', () => {
    it('in road', () => {
      cy.visit('/trains/road');
      cy.get('mat-chip').contains('Autos').should('have.attr', 'ng-reflect-selected', 'true');
      cy.get('mat-chip').contains('Züge').should('have.attr', 'ng-reflect-selected', 'false');
      cy.get('mat-chip').contains('Trams').should('have.attr', 'ng-reflect-selected', 'false');
      cy.get('mat-chip').contains('Trams').should('have.attr', 'ng-reflect-selected', 'false');
      cy.get('mat-chip').contains('Trams').should('have.attr', 'ng-reflect-selected', 'false');
      cy.get('mat-chip').contains('Züge').click();
      cy.url().should('include', '/trains/rail');
    });
    it('in rail', () => {
      cy.visit('/trains/rail');
      cy.get('mat-chip').contains('Autos').should('have.attr', 'ng-reflect-selected', 'false');
      cy.get('mat-chip').contains('Züge').should('have.attr', 'ng-reflect-selected', 'true');
      cy.get('mat-chip').contains('Autos').click();
      cy.url().should('include', '/trains/road');
    });
  });
});
