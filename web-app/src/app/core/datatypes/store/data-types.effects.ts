import { Injectable } from '@angular/core';
import { Effect } from '@ngrx/effects';
import { of } from 'rxjs';
import { catchError, filter, switchMap } from 'rxjs/operators';

import { WsEvent } from '../../socket/ws-event';
import { Versions } from '../../model/versions.model';
import { VersionInfo } from '../../model/version-info.model';
import * as fromCore from '../../store/core.actions';
import { WsService } from '../../socket/ws.service';
import { WsEventUtil } from '../../socket/ws-event-util';
import * as fromDataTypes from './data-types.actions';
import { DataTypesService } from './data-types.service';

@Injectable()
export class DataTypesEffects {

  @Effect()
  init$ = this.wsService
    .listen('[Data-eep-version]')
    .pipe(
      filter(wsEvent => wsEvent.action === 'Set'),
      switchMap((wsEvent: WsEvent) => {
          const versions: Versions = JSON.parse(wsEvent.payload);
          const versionInfo: VersionInfo = versions.versionInfo;

          return of(
            new fromCore.SetEepVersion(versionInfo.eepVersion),
            new fromCore.SetEepLuaVersion(versionInfo.luaVersion));
        }
      )
    );

  @Effect()
  dataTypes = this.dataTypesService.getActions().pipe(
    filter(wsEvent => WsEventUtil.storeAction(wsEvent) === fromDataTypes.SET_DATA_TYPES),
    switchMap(
      (wsEvent: WsEvent) => {
        return of(
          new fromDataTypes.SetDataTypes(JSON.parse(wsEvent.payload)),
          new fromCore.SetConnected(),
          new fromCore.SetConnectionStatusSuccess());
      }
    ),
    catchError(error => {
      console.log(error);
      return of(new fromCore.SetConnectionStatusError());
    })
  );

  constructor(private wsService: WsService,
              private dataTypesService: DataTypesService) {
  }
}
