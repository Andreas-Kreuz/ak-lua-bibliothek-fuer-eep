import EepSimulator from '../../../test-helpers/eep-simulator';

const simulator = new EepSimulator();

before(() => {
  simulator.simulateMap('map-01-events', 1, 81);
});

describe('Trains generally', () => {
  it('should contain an expand button which toggles the expansion', () => {
    cy.visit('/trains/rail');
    cy.get('#expand-btn1').contains('expand_more').click();
    cy.get('#expand-btn1').contains('expand_less').click();
  });

  describe('have a cam button', () => {
    it('click 1 on cam will change to rolling stock camera', () => {
      cy.visit('/trains/rail');
      cy.get('#expand-btn1').contains('expand_more').click();
      cy.get('#cam-btn0').contains('videocam').click();
      cy.readFile(simulator.fileNames.serverOutCommands, 'latin1').should(
        'eq',
        'EEPRollingstockSetActive|DBAG_Regio-424-023-EpVI\nEEPRollingstockSetUserCamera|DBAG_Regio-424-023-EpVI|21.04|-3|5|15|80\n'
      );
    });
    it('click 2 on cam will change to perspective 3', () => {
      cy.writeFile(simulator.fileNames.serverOutCommands, '');
      cy.get('#cam-btn0').contains('videocam').click();
      cy.readFile(simulator.fileNames.serverOutCommands, 'latin1').should(
        'eq',
        'EEPSetPerspectiveCamera|3|#DBAG_Regio-424-023-EpVI\n'
      );
    });
    it('click 3 on cam will change to perspective 4', () => {
      cy.writeFile(simulator.fileNames.serverOutCommands, '');
      cy.get('#cam-btn0').contains('videocam').click();
      cy.readFile(simulator.fileNames.serverOutCommands, 'latin1').should(
        'eq',
        'EEPSetPerspectiveCamera|4|#DBAG_Regio-424-023-EpVI\n'
      );
    });
    it('click 4 on cam will change to perspective 10', () => {
      cy.writeFile(simulator.fileNames.serverOutCommands, '');
      cy.get('#cam-btn0').contains('videocam').click();
      cy.readFile(simulator.fileNames.serverOutCommands, 'latin1').should(
        'eq',
        'EEPSetPerspectiveCamera|10|#DBAG_Regio-424-023-EpVI\n'
      );
    });
    it('click 5 on cam will change to perspective 9', () => {
      cy.writeFile(simulator.fileNames.serverOutCommands, '');
      cy.get('#cam-btn0').contains('videocam').click();
      cy.readFile(simulator.fileNames.serverOutCommands, 'latin1').should(
        'eq',
        'EEPSetPerspectiveCamera|9|#DBAG_Regio-424-023-EpVI\n'
      );
    });
    it('click 6 on cam will back to rollingstock camera', () => {
      cy.writeFile(simulator.fileNames.serverOutCommands, '');
      cy.get('#cam-btn0').contains('videocam').click();
      cy.readFile(simulator.fileNames.serverOutCommands, 'latin1').should(
        'eq',
        'EEPRollingstockSetActive|DBAG_Regio-424-023-EpVI\nEEPRollingstockSetUserCamera|DBAG_Regio-424-023-EpVI|21.04|-3|5|15|80\n'
      );
    });
  });

  describe('have navigation chips', () => {
    it('in road', () => {
      cy.visit('/trains/road');
      cy.get('mat-chip').contains('Autos').children('mat-icon').contains('check');
      cy.get('mat-chip').contains('Züge').not('mat-icon');
      cy.get('mat-chip').contains('Trams').not('mat-icon');
      cy.get('mat-chip').contains('Trams').not('mat-icon');
      cy.get('mat-chip').contains('Trams').not('mat-icon');
      cy.get('mat-chip').contains('Züge').click();
      cy.url().should('include', '/trains/rail');
    });
    it('in rail', () => {
      cy.visit('/trains/rail');
      cy.get('mat-chip').contains('Autos').not('mat-icon');
      cy.get('mat-chip').contains('Züge').children('mat-icon').contains('check');
      cy.get('mat-chip').contains('Autos').click();
      cy.url().should('include', '/trains/road');
    });
  });
});
