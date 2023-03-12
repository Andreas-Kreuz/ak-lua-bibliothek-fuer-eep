import useRollingStocks from './useRollingStocks';
import { RollingStock } from '@ak/web-shared';

function useRollingStock(name: string): RollingStock {
  const rollingStockRecord = useRollingStocks();
  return rollingStockRecord[name] || undefined;
}

export default useRollingStock;
