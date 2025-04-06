import { useEffect, useState } from 'react';
import TimeDesc from './model/TimeDesc';

const useStatisticsData = (updateTimes: TimeDesc[], maxEntries?: number) => {
  const [listLength, setListLength] = useState(maxEntries || 10);
  const [lastData, setLastData] = useState<TimeDesc[]>([]);
  const [list, setList] = useState<TimeDesc[][]>([]);
  const [max, setMax] = useState(100);
  const [ids, setIds] = useState<String[]>([]);

  function scale(list: TimeDesc[][]) {
    const max = getMax(list);
    return Math.round(max);
  }

  function getMax(list: TimeDesc[][]) {
    let max1 = 0;
    for (const entries of list) {
      max1 = Math.max(max1, maxOfSingleList(entries));
    }
    return max1;
  }

  function maxOfSingleList(entries: TimeDesc[]) {
    if (entries && entries.length > 0) {
      return entries.map((a) => a.ms).reduce((a, b) => a + b);
    } else {
      return 0;
    }
  }

  function deepEqual(a, b) {
    if (a === b) return true;
    if (a == null || typeof a != 'object' || b == null || typeof b != 'object') return false;
    let keysA = Object.keys(a),
      keysB = Object.keys(b);
    if (keysA.length != keysB.length) return false;
    for (let key of keysA) {
      if (!keysB.includes(key) || !deepEqual(a[key], b[key])) return false;
    }
    return true;
  }

  useEffect(() => {
    if (updateTimes && updateTimes.length >= 0 && !deepEqual(updateTimes, lastData)) {
      setLastData(updateTimes);
      const newEntry = updateTimes;
      const lastList = list;
      const last9 = lastList.length > listLength - 1 ? lastList.slice(1, listLength) : lastList;
      const newList = [...last9, newEntry];
      setList(newList);
      setMax(scale(newList));
      setIds((newEntry && newEntry.map((a) => a.id)) || []);
    }

    // return () => {
    //   setList([]);
    //   setMax(0);
    //   setIds([]);
    //   setLastData([]);
    // };
  }, [updateTimes]);

  return { max, list, ids };
};

export default useStatisticsData;
