import { useEffect, useState } from 'react';
import useStatistics from './useStatistics';
import TimeDesc from './model/TimeDesc';

const useStatisticsData = (updateTimes: TimeDesc[]) => {
  const [max, setMax] = useState(100);
  const [list, setList] = useState<TimeDesc[][]>([]);
  const [ids, setIds] = useState<String[]>([]);

  function scale(list: TimeDesc[][]) {
    const max1 = getMax(list);
    return Math.round(max1);
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

  useEffect(() => {
    if (updateTimes && updateTimes.length > 0) {
      const newEntry = updateTimes;
      const lastList = list;
      const last9 = lastList.length > 9 ? lastList.slice(1, 10) : lastList;
      const newList = [...last9, newEntry];
      setList(newList);
      setMax(scale(newList));
      setIds((newEntry && newEntry.map((a) => a.id)) || []);
    }

    return () => {
      setList([]);
      setMax(0);
      setIds([]);
    };
  }, [updateTimes]);

  return { max, list, ids };
};

export default useStatisticsData;
