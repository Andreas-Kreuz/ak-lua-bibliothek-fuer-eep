import { useTrain } from './TrainProvider';
import { TrainListEntry } from '@ak/web-shared';

function useTrains(): TrainListEntry[] {
  const trainStore = useTrain();

  return trainStore?.trainList || [];
}

export default useTrains;
