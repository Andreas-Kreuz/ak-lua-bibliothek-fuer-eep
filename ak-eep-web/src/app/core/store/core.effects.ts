import { Injectable } from '@angular/core';
import { WsService } from '../socket/ws.service';
import { Effect } from '@ngrx/effects';
import { WsEvent } from '../socket/ws-event';
import { Versions } from '../model/versions.model';
import { VersionInfo } from '../model/version-info.model';
import * as fromCore from './core.actions';
import { filter, switchMap } from 'rxjs/operators';
import { of } from 'rxjs';

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
            new fromCore.SetEepVersion(versionInfo.eepVersion),
            new fromCore.SetEepLuaVersion(versionInfo.luaVersion));
        }
      )
    );


  // @Effect()
  // fetchVersions = this.actions$
  //   .pipe(
  //     ofType(fromCore.FETCH_VERSIONS),
  //     switchMap((action: fromCore.FetchVersion) => {
  //       const url =
  //         location.protocol
  //         + '//' + location.hostname
  //         + ':' + environment.jsonPort
  //         + VERSION_PATH;
  //       console.log(url);
  //       return this.httpClient.get<Versions>(url)
  //         .pipe(
  //           map((versions: Versions) => {
  //             return versions.versionInfo;
  //           }),
  //           catchError((error) => {
  //             return throwError(error);
  //           }));
  //     }),
  //     switchMap((versionInfo: VersionInfo) => {
  //         return of(
  //           new fromCore.ShowUrlError(new EepWebUrl(VERSION_PATH, Status.SUCCESS, 'Daten geladen')),
  //           new fromCore.SetEepVersion(versionInfo.eepVersion),
  //           new fromCore.SetEepLuaVersion(versionInfo.luaVersion)
  //         );
  //       }
  //     ),
  //     catchError((err) => {
  //       return of(
  //         new fromCore.ShowUrlError(new EepWebUrl(VERSION_PATH, Status.ERROR, err.message)));
  //     })
  //   );
  //
  constructor(private wsService: WsService) {
  }
}



