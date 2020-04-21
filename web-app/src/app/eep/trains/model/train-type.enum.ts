export enum TrainType {
  Rail = 'rail',
  Road = 'road',
  Tram = 'tram',
}

export function textForTrainType(t: TrainType) {
  switch (t) {
    case TrainType.Road:
      return 'Autos';
    case TrainType.Rail:
      return 'Züge';
    case TrainType.Tram:
      return 'Trams';
    default:
      return 'UNBEKANNT';
  }
}


