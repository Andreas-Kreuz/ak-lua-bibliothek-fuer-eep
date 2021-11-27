import { Injectable } from '@angular/core';
import { Actions, createEffect, ofType } from '@ngrx/effects';
import { TrainService } from './train.service';
import { switchMap, tap } from 'rxjs/operators';

import { Train } from '../model/train.model';
import * as TrainAction from './train.actions';
import { of } from 'rxjs';
import { RollingStock } from '../model/rolling-stock.model';
import { create } from 'domain';

@Injectable()
export class TrainEffects {
  setTrains$ = createEffect(() =>
    this.actions$.pipe(
      ofType(TrainAction.trainsUpdated),
      switchMap((action) => {
        const record: Record<string, Train> = JSON.parse(action.json);
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
    this.actions$.pipe(
      ofType(TrainAction.rollingStockUpdated),
      switchMap((action) => {
        const record: Record<string, RollingStock> = JSON.parse(action.json);
        const list = Object.values(record);

        return of(
          TrainAction.setRailRollingStock({ railRollingStock: list.filter((a) => a.trackType === 'rail') }),
          TrainAction.setRoadRollingStock({ roadRollingStock: list.filter((a) => a.trackType === 'road') }),
          TrainAction.setTramRollingStock({ tramRollingStock: list.filter((a) => a.trackType === 'tram') })
        );
      })
    )
  );

  initModule = createEffect(
    () =>
      this.actions$.pipe(
        ofType(TrainAction.initModule),
        tap(() => this.trainService.connect())
      ),
    { dispatch: false }
  );

  destroyModule = createEffect(
    () =>
      this.actions$.pipe(
        ofType(TrainAction.destroyModule),
        tap(() => this.trainService.disconnect())
      ),
    { dispatch: false }
  );

  constructor(private actions$: Actions, private trainService: TrainService) {}
}
