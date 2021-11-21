import { Injectable } from '@angular/core';
import { Actions, createEffect, ofType } from '@ngrx/effects';
import { filter, switchMap, tap } from 'rxjs/operators';

import * as EepSlotAction from './eep-data.actions';
import { EepData } from '../models/eep-data.model';
import { of } from 'rxjs';
import { EepDataService } from './eep-data.service';
import { EepFreeData } from '../models/eep-free-data.model';

@Injectable()
export class EepDataEffects {
  fetchEepData = createEffect(() =>
    this.eepDataService.getDataActions().pipe(
      switchMap((data) => {
        const slots: EepData[] = Object.values(JSON.parse(data));
        for (const element of slots) {
          if (!element.name) {
            element.name = '?';
          }
        }
        return of(EepSlotAction.setSlots({ slots }));
      })
    )
  );

  fetchEepFreeData = createEffect(() =>
    this.eepDataService.getFreeDataActions().pipe(
      switchMap((data) => {
        const freeSlots: EepFreeData[] = Object.values(JSON.parse(data));
        return of(EepSlotAction.setFreeSlots({ freeSlots }));
      })
    )
  );

  closeConnection = createEffect(
    () =>
      this.actions$.pipe(
        ofType(EepSlotAction.disconnect),
        tap(() => this.eepDataService.disconnect())
      ),
    { dispatch: false }
  );

  constructor(private actions$: Actions, private eepDataService: EepDataService) {}
}
