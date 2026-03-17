import * as fromJsonData from '../../eep/server-data/EepDataStore';
import EepRollingStockDto from './EepRollingStockDto';
import { RollingStock } from '@ak/web-shared';

export class RollingStockSelector {
  private lastState: fromJsonData.State = undefined;
  private allRollingStock = new Map<string, RollingStock>();
  private trainRollingStock = new Map<string, Map<number, RollingStock>>();

  updateFromState(state: fromJsonData.State): void {
    if (state === this.lastState || !state.rooms['rolling-stocks']) {
      return;
    }

    this.allRollingStock.clear();
    this.trainRollingStock.clear();

    const rollingStockDict: Record<string, EepRollingStockDto> = state.rooms['rolling-stocks'] as unknown as Record<
      string,
      EepRollingStockDto
    >;
    Object.values(rollingStockDict).forEach((rsDto: EepRollingStockDto) => {
      const rollingStock: RollingStock = {
        id: rsDto.id,
        name: rsDto.name,
        couplingFront: rsDto.couplingFront,
        couplingRear: rsDto.couplingRear,
        length: rsDto.length,
        modelType: rsDto.modelType,
        modelTypeText: rsDto.modelTypeText,
        positionInTrain: rsDto.positionInTrain,
        propelled: rsDto.propelled,
        tag: rsDto.tag,
        nr: rsDto.nr,
        trackSystem: rsDto.trackSystem,
        trackType: rsDto.trackType,
        trackId: rsDto.trackId,
        trackDistance: rsDto.trackDistance,
        trackDirection: rsDto.trackDirection,
        trainName: rsDto.trainName,
        posX: rsDto.posX,
        posY: rsDto.posY,
        posZ: rsDto.posZ,
        mileage: rsDto.mileage,
      };
      const trainRs = this.trainRollingStock.get(rollingStock.trainName) || new Map();
      trainRs.set(rollingStock.positionInTrain, rollingStock);
      this.trainRollingStock.set(rollingStock.trainName, trainRs);
      this.allRollingStock.set(rollingStock.id, rollingStock);
    });
    this.lastState = state;
  }

  rollingStockListOfTrain(trainId: string): RollingStock[] {
    const rsList: RollingStock[] = [];
    const trainRollingStock = this.trainRollingStock.get(trainId) || new Map<number, RollingStock>();
    const sortedKeys: number[] = Array.from(trainRollingStock.keys()).sort((a, b) => a - b);
    for (const key of sortedKeys) {
      rsList.push(trainRollingStock.get(key));
    }
    return rsList;
  }

  rollingStockInTrain(trainId: string, positionOfRollingStock: number): RollingStock {
    if (this.trainRollingStock && this.trainRollingStock.get(trainId)) {
      return this.trainRollingStock.get(trainId).get(positionOfRollingStock);
    } else {
      return undefined;
    }
  }
}
