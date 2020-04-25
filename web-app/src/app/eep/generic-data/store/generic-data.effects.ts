import { Actions, Effect, ofType } from '@ngrx/effects';
import * as fromCore from '../../../core/store/core.actions';
import * as fromGenericData from './generic-data.actions';
import { catchError, map, switchMap } from 'rxjs/operators';
import { of, throwError } from 'rxjs';
import { EepWebUrl } from '../../../core/server-status/eep-web-url.model';
import { Status } from '../../../core/server-status/status.enum';
import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';


const DATA_TYPES_PATH = '/api/v1/api-entries';

@Injectable()
export class GenericDataEffects {
  @Effect()
  fetchData = this.actions$
    .pipe(
      ofType(fromGenericData.FETCH_DATA),
      switchMap((action: fromGenericData.FetchData) => {
        const url = action.payload.hostName + action.payload.path;
        console.log(url);
        return this.httpClient.get(url)
          .pipe(
            map((values) => {
              return {
                values: values,
                path: action.payload.path,
                name: action.payload.name,
              };
            }),
            catchError((error) => {
              return throwError({ error: error, path: action.payload.path });
            }));
      }),
      switchMap((data: { values, path: string, name: string }) => {
        return of(
          fromCore.showUrlError({ url: new EepWebUrl(data.path, Status.SUCCESS, 'Daten geladen') }),
          new fromGenericData.UpdateData({ type: data.name, values: data.values })
        );
      }
      ),
      catchError((err: { error: any, path: string }) => {
        return of(
          fromCore.showUrlError({ url: new EepWebUrl(err.path, Status.ERROR, err.error.message) }));
      })
    );

  constructor(private actions$: Actions,
    private httpClient: HttpClient) {
  }
}
