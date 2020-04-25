export enum Coupling {
  Ready = 1,
  Reject = 2,
  Linked = 3,
}

export function textForCoupling(t: Coupling) {
  switch (t) {
    case Coupling.Ready:
      return 'Bereit';
    case Coupling.Reject:
      return 'Abstoßen';
    case Coupling.Linked:
      return 'Gekuppelt';
    default:
      return 'UNBEKANNT';
  }
}


