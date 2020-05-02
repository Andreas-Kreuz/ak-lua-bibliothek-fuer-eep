import { Injectable } from '@angular/core';
import { Effect } from '@ngrx/effects';
import { of } from 'rxjs';
import { catchError, filter, switchMap } from 'rxjs/operators';

import { SocketEvent } from '../../socket/socket-event';
import { Versions } from '../../model/versions.model';
import { VersionInfo } from '../../model/version-info.model';
import * as fromCore from '../../store/core.actions';
import { SocketService } from '../../socket/socket-service';
import { WsEventUtil } from '../../socket/ws-event-util';
import * as fromDataTypes from './data-types.actions';
import { DataTypesService } from './data-types.service';

@Injectable()
export class DataTypesEffects {

  @Effect()
  dataTypes = this.dataTypesService.getActions().pipe(
    filter(wsEvent => WsEventUtil.storeAction(wsEvent) === fromDataTypes.setDataTypes.type),
    switchMap(
      (wsEvent: SocketEvent) => {
        return of(
          fromDataTypes.setDataTypes({ types: JSON.parse(wsEvent.payload) }),
          fromCore.setConnectionStatusSuccess());
      }
    ),
    catchError(error => {
      console.log(error);
      return of(fromCore.setConnectionStatusError());
    })
  );

  constructor(private wsService: SocketService,
    private dataTypesService: DataTypesService) {
  }
}
