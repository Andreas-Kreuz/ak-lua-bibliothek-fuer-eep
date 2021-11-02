import * as unicode from '../../../shared/unicode-symbol.model';

export enum RollingStockType {
  tenderLoco = 1,
  trailingTenderLoco = 2,
  tender = 3,
  electricLoco = 4,
  dieselLoco = 5,
  railCar = 6,
  underground = 7,
  tram = 8,
  goodsWagon = 9,
  passengerWagon = 10,
  aircraft = 11,
  machines = 12,
  waterTransport = 13,
  truck = 14,
  car = 15,
}

export const textForRollingStockType = (t: RollingStockType) => {
  switch (t) {
    case RollingStockType.aircraft:
      return 'Flugzeug';
    case RollingStockType.car:
      return 'PKW';
    case RollingStockType.dieselLoco:
      return 'Diesellok';
    case RollingStockType.electricLoco:
      return 'Elektrolok';
    case RollingStockType.goodsWagon:
      return 'Güterwagen';
    case RollingStockType.machines:
      return 'Maschine';
    case RollingStockType.passengerWagon:
      return 'Passagierwagen';
    case RollingStockType.railCar:
      return 'Triebwagen';
    case RollingStockType.tender:
      return 'Tender';
    case RollingStockType.tenderLoco:
      return 'Tenderlok';
    case RollingStockType.trailingTenderLoco:
      return 'Schlepptenderlok';
    case RollingStockType.tram:
      return 'Strassenbahn';
    case RollingStockType.truck:
      return 'LKW';
    case RollingStockType.underground:
      return 'U-Bahn / S-Bahn';
    case RollingStockType.waterTransport:
      return 'Wasserfahrzeug';
    default:
      return 'UNBEKANNT';
  }
};

export const iconForRollingStockType = (t: number) => {
  switch (t) {
    case RollingStockType.aircraft:
      return unicode.airplane;
    case RollingStockType.car:
      return unicode.car;
    case RollingStockType.dieselLoco:
      return unicode.dieselLocomotive;
    case RollingStockType.electricLoco:
      return unicode.electricLoco;
    case RollingStockType.goodsWagon:
      return unicode.trainFreightCar;
    case RollingStockType.machines:
      return unicode.machine;
    case RollingStockType.passengerWagon:
      return unicode.trainPassengerCar;
    case RollingStockType.railCar:
      return unicode.railCar;
    case RollingStockType.tender:
      return unicode.tender;
    case RollingStockType.tenderLoco:
      return unicode.tenderLoco;
    case RollingStockType.trailingTenderLoco:
      return unicode.trailingTenderLoco;
    case RollingStockType.tram:
      return unicode.tram;
    case RollingStockType.truck:
      return unicode.truck;
    case RollingStockType.underground:
      return unicode.metro;
    case RollingStockType.waterTransport:
      return unicode.ship;
    default:
      return unicode.tenderLoco;
  }
};
