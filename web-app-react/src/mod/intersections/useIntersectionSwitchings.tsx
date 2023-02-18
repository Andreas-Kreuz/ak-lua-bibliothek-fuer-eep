import { useState } from 'react';
import { useApiDataRoomHandler } from '../../io/useRoomHandler';
import IntersectionSwitching from './model/IntersectionSwitching';

function useIntersectionSwitchings(): IntersectionSwitching[] {
  const [intersectionSwitchings, setIntersectionSwitchings] = useState<IntersectionSwitching[]>([]);

  useApiDataRoomHandler('intersection-switchings', (data: Record<string, IntersectionSwitching>) => {
    setIntersectionSwitchings(Object.values(data));
  });

  return intersectionSwitchings;
}

export default useIntersectionSwitchings;
