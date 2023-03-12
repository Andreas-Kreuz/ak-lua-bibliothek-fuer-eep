import { TrainType } from '@ak/web-shared';

export const trainIconFor = (trainType: TrainType) => {
  switch (trainType) {
    case TrainType.Plane:
      return 'Flugzeug';
    case TrainType.CarWithTrailer:
      return 'sign-passenger-car-with-trailer';
    case TrainType.Bike:
      return 'sign-bicycle';
    case TrainType.Bus:
      return 'sign-busses';
    case TrainType.Car:
      return 'sign-passenger-car';
    case TrainType.Truck:
      return 'sign-truck';
    case TrainType.TruckWithTrailer:
      return 'sign-truck-with-trailer';
    case TrainType.Tram:
      return 'sign-tram';
    case TrainType.Boat:
      return 'sign-ship';
    case TrainType.TrainDiesel:
    case TrainType.TrainElectric:
    case TrainType.TrainMetro:
    case TrainType.TrainSteam:
    default:
      return 'sign-train';
  }
};
