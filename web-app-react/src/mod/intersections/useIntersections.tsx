import { useState } from 'react';
import { useApiDataRoomHandler } from '../../io/useRoomHandler';
import Intersection from './model/Intersection';

function useIntersections(): Intersection[] {
  const [intersections, setIntersections] = useState<Intersection[]>([]);

  useApiDataRoomHandler('intersections', (data: Record<string, Intersection>) => {
    setIntersections(Object.values(data));
  });

  return intersections;
}

export default useIntersections;
