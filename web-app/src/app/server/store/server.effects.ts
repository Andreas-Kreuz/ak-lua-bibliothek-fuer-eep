import { Injectable } from '@angular/core';
import { Actions, createEffect, ofType } from '@ngrx/effects';
import { ServerService } from './server.service';
import * as ServerAction from './server.actions';
import { map, switchMap } from 'rxjs/operators';
import { of } from 'rxjs';

@Injectable()
export class ServerEffects {
  changeDir$ = createEffect(
    () =>
      this.actions$.pipe(
        ofType(ServerAction.changeEepDirectoryRequest),
        map((action) => {
          this.service.changeDirectory(action.eepDir);
        })
      ),
    { dispatch: false }
  );

  dirOk$ = createEffect(() =>
    this.service.settingsDirOkReceived$.pipe(
      switchMap((data: string) => of(ServerAction.changeEepDirectorySuccess({ eepDir: data })))
    )
  );

  dirFailed$ = createEffect(() =>
    this.service.settingsDirErrorReceived$.pipe(
      switchMap((data: string) => of(ServerAction.changeEepDirectoryFailure({ eepDir: data })))
    )
  );

  urlsChanged$ = createEffect(() =>
    this.service.urlsChanged$.pipe(
      switchMap((data: string) => {
        const urls = JSON.parse(data);
        return of(ServerAction.urlsChanged({ urls }));
      })
    )
  );

  counterUpdate$ = createEffect(() =>
    this.service.counterUpdated$.pipe(
      switchMap((data: string) => {
        const eventCounter = parseInt(data, 10);
        return of(ServerAction.eventCounterChanged({ eventCounter }));
      })
    )
  );

  constructor(private service: ServerService, private actions$: Actions) {}
}
