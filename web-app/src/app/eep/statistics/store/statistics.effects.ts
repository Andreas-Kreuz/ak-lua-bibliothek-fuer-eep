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
        const list: any[] = JSON.parse(data);
        console.log(list);
        return of(
          StatisticsAction.serverControllerUpdate({
            times: [
              new TimeDesc('collect', list['ServerController.communicateWithServer-4-collect'].time),
              new TimeDesc('encode', list['ServerController.communicateWithServer-6-encode'].time),
              new TimeDesc('write', list['ServerController.communicateWithServer-7-write'].time),
            ],
          })
        );
      })
    )
  );

  constructor(private actions$: Actions, private statisticsService: StatisticsService) {}
}
