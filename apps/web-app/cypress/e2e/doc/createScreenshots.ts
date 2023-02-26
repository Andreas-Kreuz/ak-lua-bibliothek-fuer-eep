import EepSimulator from '../../test-helpers/eep-simulator';

export const defaultSizes = [
  ['iphone-xr', 'portrait'],
  ['ipad-2', 'landscape'],
];

export const createScreenshots = (
  tests: (size: string, simulator: EepSimulator) => void,
  screenShotsizes?: string[][]
) => {
  const simulator = new EepSimulator();
  (screenShotsizes || defaultSizes).forEach((size) => {
    context(`${size[0]} in ${size[1]} mode'`, () => {
      beforeEach(() => {
        Cypress.Screenshot.defaults({
          overwrite: true,
        });
        cy.viewport(size[0], size[1]);
      });
      tests(size[0], simulator);
    });
  });
};
