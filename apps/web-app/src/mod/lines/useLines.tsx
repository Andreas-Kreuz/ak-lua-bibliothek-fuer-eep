import { useApiDataRoomHandler } from '../../io/useRoomHandler';
import Line from './model/Line';
import { useState } from 'react';

function useLines(): Line[] {
  const [lines, setLines] = useState<Line[]>([]);

  useApiDataRoomHandler('public-transport-lines', (payload: string) => {
    const data: Record<string, Line> = JSON.parse(payload);
    setLines(Object.values(data));
  });

  return lines;
}

export default useLines;
