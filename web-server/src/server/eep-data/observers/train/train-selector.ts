import { Train, TrainListEntry } from 'web-shared/build/model/trains';
import * as fromJsonData from '../../eep-data-reducer';
import { RollingStockSelector } from './rolling-stock-selector';
import EepTrainDto from '../../../eep-model/eep-train-dto';

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
      const trainType: number = this.getTrainType(state, trainDto);
      const trainListEntry: TrainListEntry = {
        id: trainDto.id,
        name: trainDto.name,
        route: trainDto.route,
        line: trainDto.line,
        destination: trainDto.destination,
        trainType: trainType,
        trackType: trainDto.trackType,
      };
      this.trainListEntryMap.set(trainListEntry.id, trainListEntry);

      const train: Train = {
        ...trainListEntry,
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

  getTrainType(state: fromJsonData.State, train: EepTrainDto): number {
    return this.rollingStockSelector.rollingStockInTrain(train.id, 0).modelType;
  }
}
