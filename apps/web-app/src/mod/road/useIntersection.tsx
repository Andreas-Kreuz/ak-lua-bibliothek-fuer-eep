import { useEffect, useState } from 'react';
import Intersection from './model/Intersection';
import useIntersections from './useIntersections';

function useIntersection(id: number | undefined): Intersection | undefined {
  const all = useIntersections();
  const [intersection, setIntersection] = useState<Intersection | undefined>();

  useEffect(() => {
    all.forEach((i) => {
      if (i.id === id) {
        setIntersection(i);
      }
    });
  }, [all, id]);

  return intersection;
}

export default useIntersection;
