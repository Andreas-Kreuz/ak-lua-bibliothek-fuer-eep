import { Injectable } from '@angular/core';
import { WsService } from '../socket/ws.service';
import { Effect } from '@ngrx/effects';
import { WsEvent } from '../socket/ws-event';
import { Versions } from '../model/versions.model';
import { VersionInfo } from '../model/version-info.model';
import * as fromCore from './core.actions';
import { filter, switchMap } from 'rxjs/operators';
import { of } from 'rxjs';
import { ModuleInfo } from '../model/module-info.model';

@Injectable()
export class CoreEffects {
  @Effect()
  init$ = this.wsService
    .listen('[Data-eep-version]')
    .pipe(
      filter(wsEvent => wsEvent.action === 'Set'),
      switchMap((wsEvent: WsEvent) => {
        const versions: Versions = JSON.parse(wsEvent.payload);
        const versionInfo: VersionInfo = versions.versionInfo;

        return of(
          fromCore.setEepVersion({ version: versionInfo.eepVersion }),
          fromCore.setEepLuaVersion({ version: versionInfo.luaVersion }));
      }
      )
    );


  @Effect()
  listenForModules$ = this.wsService
    .listen('[Data-modules]')
    .pipe(
      filter(wsEvent => wsEvent.action === 'Set'),
      switchMap((wsEvent: WsEvent) => {
        const modules: ModuleInfo[] = JSON.parse(wsEvent.payload);

        return of(fromCore.setModules({ modules: modules }));
      }
      )
    );

  constructor(private wsService: WsService) {
  }
}
