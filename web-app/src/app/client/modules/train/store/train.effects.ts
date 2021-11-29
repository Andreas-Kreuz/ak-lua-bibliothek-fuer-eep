import { Injectable } from '@angular/core';
import { Actions, createEffect, ofType } from '@ngrx/effects';
import { TrainService } from './train.service';
import { switchMap, tap } from 'rxjs/operators';

import { OldTrain } from '../model/train.model';
import * as TrainAction from './train.actions';
import { of } from 'rxjs';
import { RollingStock } from '../model/rolling-stock.model';
import { TrackType } from 'web-shared/src/model/trains';

@Injectable()
export class TrainEffects {
  loadList = createEffect(
    () =>
      this.actions$.pipe(
        ofType(TrainAction.selectType),
        switchMap((action) => {
          const trackType = action.trainType;
          return of(this.trainService.listenTo(trackType));
        })
      ),
    { dispatch: false }
  );

  selectTrain = createEffect(
    () =>
      this.actions$.pipe(
        ofType(TrainAction.selectTrain),
        tap((action) => {
          this.trainService.listenToTrain(action.trainName);
        })
      ),
    { dispatch: false }
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
