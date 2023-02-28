import { useApiDataRoomHandler } from '../../io/useRoomHandler';
import { RollingStock } from '@ak/web-shared';
import { useState } from 'react';

function useTrains(): RollingStock[] {
  const [trains, setTrains] = useState<RollingStock[]>([]);

  useApiDataRoomHandler('rolling-stock', (payload: string) => {
    const data: Record<string, RollingStock> = JSON.parse(payload);
    setTrains(Object.values(data).sort((a, b) => (a.id < b.id ? -1 : 1)));
  });

  return trains;
}

export default useTrains;
