import * as fromJsonData from '../../eep/server-data/EepDataStore';
import EepTrainDto from './EepTrainDto';
import { RollingStockSelector } from './RollingStockSelector';
import { calcTrainType, Train, TrainListEntry, TrainType } from '@ak/web-shared';

export class TrainSelector {
  private state: fromJsonData.State = undefined;
  private trainMap = new Map<string, Train>();
  private trainListEntryMap = new Map<string, TrainListEntry>();

  constructor(private rollingStockSelector: RollingStockSelector) {}

  updateFromState = (state: Readonly<fromJsonData.State>): void => {
    if (this.state === state || !state.rooms['trains']) {
      return;
    }
    this.rollingStockSelector.updateFromState(state);

    this.trainMap.clear();
    this.trainListEntryMap.clear();

    const trainDict: Record<string, EepTrainDto> = state.rooms['trains'] as unknown as Record<string, EepTrainDto>;
    Object.values(trainDict).forEach((trainDto: EepTrainDto) => {
      const rollingStock = this.rollingStockSelector.rollingStockListOfTrain(trainDto.id);
      const trainType: TrainType = this.getTrainType(trainDto);
      const trainListEntry: TrainListEntry = {
        id: trainDto.id,
        name: trainDto.name,
        route: trainDto.route,
        line: trainDto.line,
        destination: trainDto.destination,
        trainType: trainType,
        trackType: trainDto.trackType,
        rollingStockCount: rollingStock.length,
        movesForward: trainDto.movesForward,
        firstRollingStockName: rollingStock[trainDto.movesForward ? 0 : rollingStock.length - 1]?.name,
        lastRollingStockName: rollingStock[trainDto.movesForward ? rollingStock.length - 1 : 0]?.name,
      };
      this.trainListEntryMap.set(trainListEntry.id, trainListEntry);

      const train: Train = {
        ...trainListEntry,
        trainType: TrainType.Bike, // FIXME
        trackSystem: trainDto.trackSystem,
        rollingStock,
        length: trainDto.length,
        direction: trainDto.direction,
        speed: trainDto.speed,
      };

      this.trainMap.set(train.id, train);
    });
  };

  getTrainList(trackType: string): TrainListEntry[] {
    return Array.from(this.trainListEntryMap.values())
      .filter((v: TrainListEntry) => v.trackType === trackType)
      .sort();
  }

  getTrain(trainId: string): Train {
    return this.trainMap.get(trainId);
  }

  getTrainType(train: EepTrainDto): TrainType {
    if (this.rollingStockSelector.rollingStockInTrain(train.id, 0)) {
      return calcTrainType(
        this.rollingStockSelector.rollingStockInTrain(train.id, 0).modelType,
        train.rollingStockCount
      );
    } else {
      return TrainType.TrainElectric;
    }
  }
}
