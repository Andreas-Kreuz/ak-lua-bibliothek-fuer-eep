import { Injectable } from '@angular/core';
import { Actions, createEffect, ofType } from '@ngrx/effects';
import { TrainService } from './train.service';
import { filter, switchMap, tap } from 'rxjs/operators';

import { Train } from '../model/train.model';
import * as TrainAction from './train.actions';
import { of } from 'rxjs';
import { RollingStock } from '../model/rolling-stock.model';

@Injectable()
export class TrainEffects {
  setTrains$ = createEffect(() =>
    this.trainService.trainsActions$().pipe(
      switchMap((data) => {
        const record: Record<string, Train> = JSON.parse(data);
        const list = Object.values(record);

        return of(
          TrainAction.setRailTrains({ railTrains: list.filter((a) => a.trackType === 'rail') }),
          TrainAction.setRoadTrains({ roadTrains: list.filter((a) => a.trackType === 'road') }),
          TrainAction.setTramTrains({ tramTrains: list.filter((a) => a.trackType === 'tram') })
        );
      })
    )
  );

  setRollingStock$ = createEffect(() =>
    this.trainService.rollingStockActions$().pipe(
      switchMap((data) => {
        const record: Record<string, RollingStock> = JSON.parse(data);
        const list = Object.values(record);

        return of(
          TrainAction.setRailRollingStock({ railRollingStock: list.filter((a) => a.trackType === 'rail') }),
          TrainAction.setRoadRollingStock({ roadRollingStock: list.filter((a) => a.trackType === 'road') }),
          TrainAction.setTramRollingStock({ tramRollingStock: list.filter((a) => a.trackType === 'tram') })
        );
      })
    )
  );

  closeConnection = createEffect(
    () =>
      this.actions$.pipe(
        ofType(TrainAction.disconnect),
        tap(() => this.trainService.disconnect())
      ),
    { dispatch: false }
  );

  constructor(private actions$: Actions, private trainService: TrainService) {}
}
