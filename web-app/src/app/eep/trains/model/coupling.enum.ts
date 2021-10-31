export enum Coupling {
  ready = 1,
  reject = 2,
  linked = 3,
}

export const textForCoupling = (t: Coupling) => {
  switch (t) {
    case Coupling.ready:
      return 'Bereit';
    case Coupling.reject:
      return 'Abstoßen';
    case Coupling.linked:
      return 'Gekuppelt';
    default:
      return 'UNBEKANNT';
  }
};
