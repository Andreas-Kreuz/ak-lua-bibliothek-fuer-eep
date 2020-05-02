import { Injectable } from '@angular/core';
import { Effect, createEffect } from '@ngrx/effects';
import { Versions } from '../model/versions.model';
import { VersionInfo } from '../model/version-info.model';
import * as CoreAction from './core.actions';
import { filter, switchMap, map } from 'rxjs/operators';
import { of } from 'rxjs';
import { ModuleInfo } from '../model/module-info.model';
import { CoreService } from './core-service';

@Injectable()
export class CoreEffects {
  versionChanged$ = createEffect(() =>
    this.coreService.versionChanged$.pipe(
      switchMap((data) => {
        if ('' !== data) {
          const versions: Versions = JSON.parse(data);
          const versionInfo: VersionInfo = versions.versionInfo;

          return of(
            CoreAction.setEepVersion({ version: versionInfo.eepVersion }),
            CoreAction.setEepLuaVersion({ version: versionInfo.luaVersion })
          );
        } else {
          CoreAction.setEepVersion({ version: undefined });
          CoreAction.setEepLuaVersion({ version: undefined });
        }
      })
    )
  );

  modulesChanged$ = createEffect(() =>
    this.coreService.modulesChanged$.pipe(
      map((data) => {
        let modules: ModuleInfo[] = [];
        if ('' !== data) {
          modules = JSON.parse(data);
        }
        return CoreAction.setModules({ modules: modules });
      })
    )
  );

  constructor(private coreService: CoreService) {}
}
