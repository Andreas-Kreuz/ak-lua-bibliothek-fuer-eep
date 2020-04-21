import * as unicode from '../../../shared/unicode-symbol.model';

export enum RollingStockType {
  TenderLoco = 1,
  TrailingTenderLoco = 2,
  Tender = 3,
  ElectricLoco = 4,
  DieselLoco = 5,
  RailCar = 6,
  Underground = 7,
  Tram = 8,
  GoodsWagon = 9,
  PassengerWagon = 10,
  Aircraft = 11,
  Machines = 12,
  WaterTransport = 13,
  Truck = 14,
  Car = 15
}

export function textForRollingStockType(t: RollingStockType) {
  switch (t) {
    case RollingStockType.Aircraft:
      return 'Flugzeug';
    case RollingStockType.Car:
      return 'PKW';
    case RollingStockType.DieselLoco:
      return 'Diesellok';
    case RollingStockType.ElectricLoco:
      return 'Elektrolok';
    case RollingStockType.GoodsWagon:
      return 'Güterwagen';
    case RollingStockType.Machines:
      return 'Maschine';
    case RollingStockType.PassengerWagon:
      return 'Passagierwagen';
    case RollingStockType.RailCar:
      return 'Triebwagen';
    case RollingStockType.Tender:
      return 'Tender';
    case RollingStockType.TenderLoco:
      return 'Tenderlok';
    case RollingStockType.TrailingTenderLoco:
      return 'Schlepptenderlok';
    case RollingStockType.Tram:
      return 'Strassenbahn';
    case RollingStockType.Truck:
      return 'LKW';
    case RollingStockType.Underground:
      return 'U-Bahn / S-Bahn';
    case RollingStockType.WaterTransport:
      return 'Wasserfahrzeug';
    default:
      return 'UNBEKANNT';
  }
}

export function iconForRollingStockType(t: number) {
  switch (t) {
    case RollingStockType.Aircraft:
      return unicode.airplane;
    case RollingStockType.Car:
      return unicode.car;
    case RollingStockType.DieselLoco:
      return unicode.dieselLocomotive;
    case RollingStockType.ElectricLoco:
      return unicode.electricLoco;
    case RollingStockType.GoodsWagon:
      return unicode.trainFreightCar;
    case RollingStockType.Machines:
      return unicode.machine;
    case RollingStockType.PassengerWagon:
      return unicode.trainPassengerCar;
    case RollingStockType.RailCar:
      return unicode.railCar;
    case RollingStockType.Tender:
      return unicode.tender;
    case RollingStockType.TenderLoco:
      return unicode.tenderLoco;
    case RollingStockType.TrailingTenderLoco:
      return unicode.trailingTenderLoco;
    case RollingStockType.Tram:
      return unicode.tram;
    case RollingStockType.Truck:
      return unicode.truck;
    case RollingStockType.Underground:
      return unicode.metro;
    case RollingStockType.WaterTransport:
      return unicode.ship;
    default:
      return unicode.tenderLoco;
  }
}


