import { Injectable } from '@angular/core';
import { Actions, createEffect } from '@ngrx/effects';
import { filter, switchMap } from 'rxjs/operators';

import { SetFreeSlots, SetSlots } from './eep-data.actions';
import { EepData } from '../models/eep-data.model';
import { of } from 'rxjs';
import { EepDataService } from './eep-data.service';
import { EepFreeData } from '../models/eep-free-data.model';

@Injectable()
export class EepDataEffects {
  fetchEepData = createEffect(() =>
    this.eepDataService.getDataActions().pipe(
      switchMap((data) => {
        const list: EepData[] = Object.values(JSON.parse(data));
        for (const element of list) {
          if (!element.name) {
            element.name = '?';
          }
        }
        return of(new SetSlots(list));
      })
    )
  );

  fetchEepFreeData = createEffect(() =>
    this.eepDataService.getFreeDataActions().pipe(
      switchMap((data) => {
        const list: EepFreeData[] = Object.values(JSON.parse(data));
        return of(new SetFreeSlots(list));
      })
    )
  );

  constructor(private actions$: Actions, private eepDataService: EepDataService) {}
}
