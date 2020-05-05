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
        const list: EepData[] = JSON.parse(data);
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
        const list: EepFreeData[] = JSON.parse(data);
        return of(new SetFreeSlots(list));
      })
    )
  );
  //
  // fetchEepData = this.actions$
  //   .pipe(
  //     ofType(fromEep.FETCH_SLOTS),
  //     switchMap((action: fromEep.FetchSlots) => {
  //       const url =
  //         location.protocol
  //         + '//' + location.hostname
  //         + ':' + environment.jsonPort
  //         + SAVE_SLOT_PATH;
  //       console.log(url);
  //       return this.httpClient.get<EepData[]>(url)
  //         .pipe(
  //           map((list: EepData[]) => {
  //             for (const element of list) {
  //               if (!element.name) {
  //                 element.name = '?';
  //               }
  //             }
  //             return {list: list, url: url};
  //           }),
  //           catchError(err => {
  //             return throwError(err);
  //           })
  //         );
  //     }),
  //     switchMap((t: { list: EepData[], url: string }) => {
  //         return [
  //           new ErrorActions.ShowUrlError(
  //             new EepWebUrl(SAVE_SLOT_PATH, Status.SUCCESS,
  //               'Daten geladen.')),
  //           new SetSlots(t.list),
  //         ];
  //       }
  //     ),
  //     catchError(err => {
  //       console.log(err);
  //       return of(
  //         new ErrorActions.ShowUrlError(new EepWebUrl(SAVE_SLOT_PATH, Status.ERROR, err.message)));
  //     })
  //   );

  constructor(private actions$: Actions, private eepDataService: EepDataService) {}
}
