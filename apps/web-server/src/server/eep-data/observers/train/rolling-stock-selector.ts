import EepRollingStockDto from '../../../eep-model/eep-rolling-stock-dto';
import * as fromJsonData from '../../eep-data-reducer';
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
        couplingRear: rsDto.couplingFront,
        length: rsDto.length,
        modelType: rsDto.modelType,
        positionInTrain: rsDto.positionInTrain,
        propelled: rsDto.propelled,
        tag: rsDto.tag,
        trackSystem: rsDto.trackSystem,
        trackType: rsDto.trackType,
        trainName: rsDto.trainName,
      };
      const trainRs = this.trainRollingStock.get(rollingStock.trainName) || new Map();
      trainRs.set(rollingStock.positionInTrain, rollingStock);
      this.trainRollingStock.set(rollingStock.trainName, trainRs);
      this.allRollingStock.set(rollingStock.id, rollingStock);
    });
  }

  rollingStockListOfTrain(trainId: string): RollingStock[] {
    const rsList: RollingStock[] = [];
    const trainRollingStock = this.trainRollingStock.get(trainId) || new Map<number, RollingStock>();
    const sortedKeys: number[] = Array.from(trainRollingStock.keys()).sort();
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
