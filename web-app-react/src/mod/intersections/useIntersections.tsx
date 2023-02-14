import { SetStateAction, useEffect, useState } from 'react';
import { ApiDataRoom } from 'web-shared';
import { useRoomHandler } from '../../io/useRoomHandler';
import Intersection from './Intersection';

function useIntersections(): Intersection[] {
  const [intersections, setIntersections] = useState<Intersection[]>([]);

  useRoomHandler('intersections', (data: Record<string, Intersection>) => {
    setIntersections(Object.values(data));
  });

  return intersections;
}

export default useIntersections;
