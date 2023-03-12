import { useTrain } from './TrainProvider';
import { RollingStock } from '@ak/web-shared';

function useRollingStocks(): Record<string, RollingStock> {
  const trainStore = useTrain();
  return trainStore?.rollingStock || {};
}

export default useRollingStocks;
