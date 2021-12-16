export enum TrainType {
  road = 'road',
  tram = 'tram',
  rail = 'rail',
  auxiliary = 'auxiliary',
  control = 'control',
}

export const textForTrainType = (t: TrainType) => {
  switch (t) {
    case TrainType.road:
      return 'Autos';
    case TrainType.rail:
      return 'Züge';
    case TrainType.tram:
      return 'Trams';
    case TrainType.auxiliary:
      return 'Sonstige';
    case TrainType.control:
      return 'Steuerstrecken';
    default:
      return 'UNBEKANNT';
  }
};
