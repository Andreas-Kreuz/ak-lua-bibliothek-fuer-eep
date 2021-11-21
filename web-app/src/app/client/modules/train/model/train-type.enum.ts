export enum TrainType {
  rail = 'rail',
  road = 'road',
  tram = 'tram',
}

export const textForTrainType = (t: TrainType) => {
  switch (t) {
    case TrainType.road:
      return 'Autos';
    case TrainType.rail:
      return 'Züge';
    case TrainType.tram:
      return 'Trams';
    default:
      return 'UNBEKANNT';
  }
};
