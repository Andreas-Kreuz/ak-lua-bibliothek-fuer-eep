import { useState } from 'react';
import { useApiDataRoomHandler } from '../../io/useRoomHandler';
import TimeDesc from './model/TimeDesc';

function useStatistics() {
  const [updateTimes, setUpdateTimes] = useState<TimeDesc[]>([]);
  const [initializationTimes, setIntitializationTimes] = useState<TimeDesc[]>([]);
  const [controllerUpdateTimes, setControllerUpdateTimes] = useState<TimeDesc[]>([]);

  useApiDataRoomHandler(
    'runtime',
    (payload: string) => {
      const record: Record<string, { id: string; count: number; time: number }> = JSON.parse(payload);

      const parsedTimes: Record<string, TimeDesc[]> = {};
      for (const suffix of ['.syncState', '.initialize']) {
        const times = [];
        for (const collector of [
          'core.ModulesStatePublisher',
          'core.VersionStatePublisher',
          'data.CrossingStatePublisher',
          'data.DataSlotsStatePublisher',
          'data.SignalStatePublisher',
          'data.StructureStatePublisher',
          'data.SwitchStatePublisher',
          'data.TimeStatePublisher',
          'data.TrafficLightModelStatePublisher',
          'data.TrainsAndTracksStatePublisher',
        ]) {
          const collectorName = 'StatePublisher.ak.' + collector + suffix;
          if (record[collectorName]) {
            times.push(new TimeDesc(collector, record[collectorName].time));
          } else {
            times.push(new TimeDesc(collector, 0));
          }
        }
        parsedTimes[suffix] = times;
      }

      setUpdateTimes(parsedTimes['.syncState']);
      setIntitializationTimes(parsedTimes['.initialize']);
      setControllerUpdateTimes([
        new TimeDesc(
          'collect',
          record['ServerController.communicateWithServer-4-collect']
            ? record['ServerController.communicateWithServer-4-collect'].time
            : 0,
        ),
        new TimeDesc(
          'encode',
          record['ServerController.communicateWithServer-6-encode']
            ? record['ServerController.communicateWithServer-6-encode'].time
            : 0,
        ),
        new TimeDesc(
          'write',
          record['ServerController.communicateWithServer-7-write']
            ? record['ServerController.communicateWithServer-7-write'].time
            : 0,
        ),
      ]);
    },
    () => {
      setUpdateTimes([]);
      setIntitializationTimes([]);
      setControllerUpdateTimes([]);
    },
  );

  return [updateTimes, initializationTimes, controllerUpdateTimes];
}

export default useStatistics;
