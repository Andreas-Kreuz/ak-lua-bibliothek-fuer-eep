import { TrainListEntry } from 'web-shared/build/model/trains';
import { RollingStockType } from './rolling-stock-type.enum';

export const trainIconFor = (train: TrainListEntry) => {
  switch (train.trainType) {
    case RollingStockType.aircraft:
      return 'Flugzeug';
    case RollingStockType.car:
      return train.rollingStockCount > 1 ? 'sign-passenger-car-with-trailer' : 'sign-passenger-car';
    case RollingStockType.truck:
      return train.rollingStockCount > 1 ? 'sign-truck-with-trailer' : 'sign-truck';
    case RollingStockType.tram:
      return 'sign-tram';
    case RollingStockType.waterTransport:
      return 'sign-ship';
    case RollingStockType.dieselLoco:
    case RollingStockType.electricLoco:
    case RollingStockType.goodsWagon:
    case RollingStockType.machines:
    case RollingStockType.passengerWagon:
    case RollingStockType.railCar:
    case RollingStockType.tender:
    case RollingStockType.tenderLoco:
    case RollingStockType.trailingTenderLoco:
    case RollingStockType.underground:
    default:
      return 'sign-train';
  }
};
