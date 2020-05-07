import { Injectable } from '@angular/core';
import { Actions, createEffect } from '@ngrx/effects';
import { TrainService } from './train.service';
import { filter, switchMap } from 'rxjs/operators';

import { Train } from '../model/train.model';
import * as fromTrains from './train.actions';
import { of } from 'rxjs';
import { RollingStock } from '../model/rolling-stock.model';

@Injectable()
export class TrainEffects {
  setRailTrains$ = createEffect(() =>
    this.trainService.railTrainsActions$().pipe(
      switchMap((data) => {
        const list: Train[] = JSON.parse(data);
        return of(new fromTrains.SetRailTrains(list));
      })
    )
  );

  setRailRollingStock$ = createEffect(() =>
    this.trainService.railRollingStockActions$().pipe(
      switchMap((data) => {
        const list: RollingStock[] = JSON.parse(data);
        return of(new fromTrains.SetRailRollingStock(list));
      })
    )
  );

  setRoadTrains$ = createEffect(() =>
    this.trainService.roadTrainsActions$().pipe(
      switchMap((data) => {
        const list: Train[] = JSON.parse(data);
        return of(new fromTrains.SetRoadTrains(list));
      })
    )
  );

  setRoadRollingStock$ = createEffect(() =>
    this.trainService.roadRollingStockActions$().pipe(
      switchMap((data) => {
        const list: RollingStock[] = JSON.parse(data);
        return of(new fromTrains.SetRoadRollingStock(list));
      })
    )
  );

  setTramTrains$ = createEffect(() =>
    this.trainService.tramTrainsActions$().pipe(
      switchMap((data) => {
        const list: Train[] = JSON.parse(data);
        return of(new fromTrains.SetTramTrains(list));
      })
    )
  );

  setTramRollingStock$ = createEffect(() =>
    this.trainService.tramRollingStockActions$().pipe(
      switchMap((data) => {
        const list: RollingStock[] = JSON.parse(data);
        return of(new fromTrains.SetTramRollingStock(list));
      })
    )
  );

  constructor(private actions$: Actions, private trainService: TrainService) {}
}
