import { Injectable } from '@angular/core';
import { createEffect } from '@ngrx/effects';
import { Versions } from '../model/versions.model';
import { VersionInfo } from '../model/version-info.model';
import * as CoreAction from './core.actions';
import { filter, switchMap, map, tap, concatMap } from 'rxjs/operators';
import { of } from 'rxjs';
import { ModuleInfo } from '../model/module-info.model';
import { CoreService } from './core-service';

@Injectable()
export class CoreEffects {
  versionChanged$ = createEffect(() =>
    this.coreService.versionChanged$.pipe(
      concatMap((data) => {
        if (data && '' !== data) {
          const versions: Versions = JSON.parse(data);
          const versionInfo: VersionInfo = versions.versionInfo;

          return of(
            CoreAction.setEepVersion({ version: versionInfo.eepVersion }),
            CoreAction.setEepLuaVersion({ version: versionInfo.luaVersion })
          );
        } else {
          return of(
            CoreAction.setEepVersion({ version: undefined }),
            CoreAction.setEepLuaVersion({ version: undefined })
          );
        }
      })
    )
  );

  modulesChanged$ = createEffect(() =>
    this.coreService.modulesChanged$.pipe(
      concatMap((data) => {
        let modules: ModuleInfo[] = [];
        if (data && '' !== data) {
          modules = JSON.parse(data);
        }
        return of(CoreAction.setModules({ modules: modules }), CoreAction.setModulesAvailable());
      })
    )
  );

  constructor(private coreService: CoreService) {}
}
