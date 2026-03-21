import { useState } from 'react';
import { useApiDataRoomHandler } from '../../io/useRoomHandler';
import TimeDesc from './model/TimeDesc';

function useStatistics() {
  const [publisherSyncTimes, setPublisherSyncTimes] = useState<TimeDesc[]>([]);
  const [publisherInitTimes, setPublisherInitTimes] = useState<TimeDesc[]>([]);
  const [moduleRunTimes, setModuleRunTimes] = useState<TimeDesc[]>([]);
  const [moduleInitTimes, setModuleInitTimes] = useState<TimeDesc[]>([]);
  const [controllerUpdateTimes, setControllerUpdateTimes] = useState<TimeDesc[]>([]);

  useApiDataRoomHandler(
    'runtime',
    (payload: string) => {
      const record: Record<string, { id: string; count: number; time: number }> = JSON.parse(payload);

      const publisherTimes: Record<string, TimeDesc[]> = {};
      for (const suffix of ['.syncState', '.initialize']) {
        const times = [];
        for (const collector of [
          'core.ModulesStatePublisher',
          'core.VersionStatePublisher',
          'data.RoadStatePublisher',
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
        publisherTimes[suffix] = times;
      }

      const moduleTimes: Record<string, TimeDesc[]> = {};
      for (const suffix of ['.run', '.init']) {
        const times = [];
        for (const collector of [
          'core.CoreCeModule',
          'data.DataCeModule',
          'scheduler.SchedulerCeModule',
          'road.RoadCeModule',
        ]) {
          const collectorName = 'CeModule.ak.' + collector + suffix;
          if (record[collectorName]) {
            times.push(new TimeDesc(collector, record[collectorName].time));
          } else {
            times.push(new TimeDesc(collector, 0));
          }
        }
        publisherTimes[suffix] = times;
      }

      setPublisherSyncTimes(publisherTimes['.syncState']);
      setPublisherInitTimes(publisherTimes['.initialize']);
      setModuleRunTimes(publisherTimes['.run']);
      setModuleInitTimes(publisherTimes['.init']);
      setControllerUpdateTimes([
        new TimeDesc(
          'Wait for server to be ready',
          record['MainLoopRunner.runCycle-5-waitForServer']
            ? record['MainLoopRunner.runCycle-5-waitForServer'].time
            : 0,
        ),
        new TimeDesc(
          'Command execution',
          record['MainLoopRunner.runCycle-6-commands'] ? record['MainLoopRunner.runCycle-6-commands'].time : 0,
        ),
        new TimeDesc(
          'Server output',
          record['MainLoopRunner.runCycle-7-serverOutput']
            ? record['MainLoopRunner.runCycle-7-serverOutput'].time
            : 0,
        ),
        new TimeDesc(
          'DataStore write',
          record['MainLoopRunner.runCycle-8-dataStoreWrite']
            ? record['MainLoopRunner.runCycle-8-dataStoreWrite'].time
            : 0,
        ),
      ]);
    },
    () => {
      setPublisherSyncTimes([]);
      setPublisherInitTimes([]);
      setControllerUpdateTimes([]);
      setModuleInitTimes([]);
      setModuleRunTimes([]);
    },
  );

  return [publisherSyncTimes, publisherInitTimes, controllerUpdateTimes, moduleInitTimes, moduleRunTimes];
}

export default useStatistics;
