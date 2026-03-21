import { useEffect, useState } from 'react';
import IntersectionSwitching from './model/IntersectionSwitching';
import useIntersectionSwitchings from './useIntersectionSwitchings';

function useIntersectionSwitching(id: string | undefined): IntersectionSwitching[] {
  const allSwitchings = useIntersectionSwitchings();
  const [switchings, setSwitchings] = useState<IntersectionSwitching[]>([]);

  useEffect(() => {
    setSwitchings(
      allSwitchings
        .filter((is: IntersectionSwitching) => id === is.intersectionId)
        .sort((a, b) => a.name.localeCompare(b.name))
    );
  }, [allSwitchings, id]);

  return switchings;
}

export default useIntersectionSwitching;
