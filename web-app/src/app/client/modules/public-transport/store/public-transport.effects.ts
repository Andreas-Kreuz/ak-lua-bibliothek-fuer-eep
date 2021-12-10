import { Injectable } from '@angular/core';
import { Actions, createEffect, ofType } from '@ngrx/effects';
import { of, pipe } from 'rxjs';
import { map, switchMap, tap } from 'rxjs/operators';
import { LuaSetting, LuaSettings } from 'web-shared/build/model/settings';

import * as PublicTransportAction from './public-transport.actions';
import { PublicTransportService } from './public-transport.service';

@Injectable()
export class PublicTransportEffects {
  initModule = createEffect(
    () =>
      this.actions$.pipe(
        ofType(PublicTransportAction.initModule),
        tap(() => this.publicTransportService.connect())
      ),
    { dispatch: false }
  );

  destroyModule = createEffect(
    () =>
      this.actions$.pipe(
        ofType(PublicTransportAction.destroyModule),
        tap(() => this.publicTransportService.disconnect())
      ),
    { dispatch: false }
  );

  // effect will not dispatch any actions
  changeSettingCommand$ = createEffect(
    () =>
      this.actions$.pipe(
        ofType(PublicTransportAction.settingChanged),
        map((action) => {
          this.publicTransportService.changeModuleSettings(action.setting, action.value);
        })
      ),
    { dispatch: false }
  );

  constructor(private actions$: Actions, private publicTransportService: PublicTransportService) {}
}
