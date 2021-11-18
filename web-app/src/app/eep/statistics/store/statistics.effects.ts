import { Injectable } from '@angular/core';
import { Actions, createEffect } from '@ngrx/effects';
import { switchMap } from 'rxjs/operators';
import { of } from 'rxjs';
import StatisticsService from './statistics.service';
import * as StatisticsAction from './statistics.actions';
import TimeDesc from './time-desc';
import { props } from '@ngrx/store';

@Injectable()
export class StatisticsEffects {
  fetchIntersectionTrafficLights$ = createEffect(() =>
    this.statisticsService.getServerCollectorStats().pipe(
      switchMap((data) => {
        const record: Record<string, { id: string; count: number; time: number }> = JSON.parse(data);

        const parsedTimes = {};
        for (const suffix of ['.collectData', '.initialize']) {
          const times = [];
          for (const collector of [
            'core.ModulesJsonCollector',
            'core.VersionJsonCollector',
            'data.CrossingJsonCollector',
            'data.DataSlotsJsonCollector',
            'data.SignalJsonCollector',
            'data.StructureJsonCollector',
            'data.SwitchJsonCollector',
            'data.TimeJsonCollector',
            'data.TrafficLightModelJsonCollector',
            'data.TrainsAndTracksJsonCollector',
          ]) {
            const collectorName = 'JsonCollector.ak.' + collector + suffix;
            if (record[collectorName]) {
              times.push(new TimeDesc(collector, record[collectorName].time));
            } else {
              console.warn('No such collector: ' + collectorName, record[collectorName]);
            }
          }
          parsedTimes[suffix] = times;
        }

        return of(
          StatisticsAction.dataCollectorUpdate({ times: parsedTimes['.collectData'] }),
          StatisticsAction.dataInitializeUpdate({ times: parsedTimes['.initialize'] }),
          StatisticsAction.serverControllerUpdate({
            times: [
              new TimeDesc(
                'collect',
                record['ServerController.communicateWithServer-4-collect']
                  ? record['ServerController.communicateWithServer-4-collect'].time
                  : 0
              ),
              new TimeDesc(
                'encode',
                record['ServerController.communicateWithServer-6-encode']
                  ? record['ServerController.communicateWithServer-6-encode'].time
                  : 0
              ),
              new TimeDesc(
                'write',
                record['ServerController.communicateWithServer-7-write']
                  ? record['ServerController.communicateWithServer-7-write'].time
                  : 0
              ),
            ],
          })
        );
      })
    )
  );

  constructor(private actions$: Actions, private statisticsService: StatisticsService) {}
}
