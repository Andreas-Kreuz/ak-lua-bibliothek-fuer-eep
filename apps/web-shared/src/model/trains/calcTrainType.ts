import { RollingStockType } from './RollingStockType';
import TrainType from './TrainType';

const calcTrainType = (firstRollingStockType: number, rollingStockCount: number): TrainType => {
  switch (firstRollingStockType) {
    case RollingStockType.aircraft:
      return TrainType.Plane;
    case RollingStockType.car:
      return rollingStockCount > 1 ? TrainType.CarWithTrailer : TrainType.Car;
    case RollingStockType.truck:
      return rollingStockCount > 1 ? TrainType.TruckWithTrailer : TrainType.Truck;
    case RollingStockType.tram:
      return TrainType.Tram;
    case RollingStockType.waterTransport:
      return TrainType.Boat;
    case RollingStockType.dieselLoco:
      return TrainType.TrainDiesel;
    case RollingStockType.electricLoco:
      return TrainType.TrainElectric;
    case RollingStockType.tender:
    case RollingStockType.tenderLoco:
    case RollingStockType.trailingTenderLoco:
      return TrainType.TrainSteam;
    case RollingStockType.underground:
    case RollingStockType.goodsWagon:
    case RollingStockType.machines:
    case RollingStockType.passengerWagon:
    case RollingStockType.railCar:
    default:
      return TrainType.TrainElectric;
  }
};

export default calcTrainType;
export { calcTrainType };
