import { Actions, createEffect, ofType } from '@ngrx/effects';
import * as fromCore from '../../../../core/store/core.actions';
import * as fromGenericData from './generic-data.actions';
import { catchError, map, switchMap } from 'rxjs/operators';
import { of, throwError } from 'rxjs';
import { EepWebUrl } from '../../../../core/server-status/eep-web-url.model';
import { Status } from '../../../../core/server-status/status.enum';
import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';

const DATA_TYPES_PATH = '/api/v1/api-entries';

@Injectable()
export class GenericDataEffects {
  fetchData = createEffect(() =>
    this.actions$.pipe(
      ofType(fromGenericData.fetchData),
      switchMap((action) => {
        const url = action.hostName + action.path;
        console.log(url);
        return this.httpClient.get(url).pipe(
          map((values) => ({
            values,
            path: action.path,
            name: action.name,
          })),
          catchError((error) => throwError({ error, path: action.path }))
        );
      }),
      switchMap((data: { values; path: string; name: string }) =>
        of(fromGenericData.updateData({ dataType: data.name, values: data.values }))
      ),
      catchError((err: { error: any; path: string }) => of(fromGenericData.updateData({ dataType: '', values: {} })))
    )
  );

  constructor(private actions$: Actions, private httpClient: HttpClient) {}
}
