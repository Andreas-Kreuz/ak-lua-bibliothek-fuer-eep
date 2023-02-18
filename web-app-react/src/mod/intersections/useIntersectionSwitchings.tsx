import { useState } from 'react';
import { useRoomHandler } from '../../io/useRoomHandler';
import IntersectionSwitching from './model/IntersectionSwitching';

function useIntersectionSwitchings(): IntersectionSwitching[] {
  const [intersectionSwitchings, setIntersectionSwitchings] = useState<IntersectionSwitching[]>([]);

  useRoomHandler('intersection-switchings', (data: Record<string, IntersectionSwitching>) => {
    setIntersectionSwitchings(Object.values(data));
  });

  return intersectionSwitchings;
}

export default useIntersectionSwitchings;
