import { Injectable } from '@angular/core';
import { Actions, Effect } from '@ngrx/effects';
import { TrainService } from './train.service';
import { filter, switchMap } from 'rxjs/operators';

import { Train } from '../model/train.model';
import * as fromTrains from './train.actions';
import { of } from 'rxjs';
import { RollingStock } from '../model/rolling-stock.model';

@Injectable()
export class TrainEffects {
  @Effect()
  setRailTrains$ = this.trainService.railTrainsActions$().pipe(
    switchMap(
      data => {
        const list: Train[] = JSON.parse(data);
        return of(new fromTrains.SetRailTrains(list));
      }
    )
  );

  @Effect()
  setRailRollingStock$ = this.trainService.railRollingStockActions$().pipe(
    switchMap(
      data => {
        const list: RollingStock[] = JSON.parse(data);
        return of(new fromTrains.SetRailRollingStock(list));
      }
    )
  );

  @Effect()
  setRoadTrains$ = this.trainService.roadTrainsActions$().pipe(
    switchMap(
      data => {
        const list: Train[] = JSON.parse(data);
        return of(new fromTrains.SetRoadTrains(list));
      }
    )
  );

  @Effect()
  setRoadRollingStock$ = this.trainService.roadRollingStockActions$().pipe(
    switchMap(
      data => {
        const list: RollingStock[] = JSON.parse(data);
        return of(new fromTrains.SetRoadRollingStock(list));
      }
    )
  );

  @Effect()
  setTramTrains$ = this.trainService.tramTrainsActions$().pipe(
    switchMap(
      data => {
        const list: Train[] = JSON.parse(data);
        return of(new fromTrains.SetTramTrains(list));
      }
    )
  );

  @Effect()
  setTramRollingStock$ = this.trainService.tramRollingStockActions$().pipe(
    switchMap(
      data => {
        const list: RollingStock[] = JSON.parse(data);
        return of(new fromTrains.SetTramRollingStock(list));
      }
    )
  );

  constructor(private actions$: Actions,
              private trainService: TrainService) {
  }
}
