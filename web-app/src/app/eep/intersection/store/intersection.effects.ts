import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { Actions, ofType, createEffect } from '@ngrx/effects';
import { map, switchMap } from 'rxjs/operators';
import * as IntersectionActions from './intersection.actions';
import { of } from 'rxjs';
import { IntersectionLane } from '../models/intersection-lane.model';
import * as fromSignals from '../../signals/store/signal.actions';
import { IntersectionTrafficLight } from '../models/intersection-traffic-light.model';
import { IntersectionService } from './intersection.service';
import { SocketEvent } from '../../../core/socket/socket-event';
import { Intersection } from '../models/intersection.model';
import { IntersectionSwitching } from '../models/intersection-switching.model';
import { LuaSettings } from '../../../shared/model/lua-settings';
import { LuaSetting } from '../../../shared/model/lua-setting';
import { THIS_EXPR } from '@angular/compiler/src/output/output_ast';

@Injectable()
export class IntersectionEffects {
  fetchIntersectionTrafficLights$ = createEffect(() =>
    this.intersectionService.getTrafficLightActions().pipe(
      switchMap((data) => {
        const list: IntersectionTrafficLight[] = JSON.parse(data);
        const signalModels = new Map<number, string>();
        for (const element of list) {
          if (!element.lightStructures) {
            element.lightStructures = {};
          }
          if (!element.axisStructures) {
            element.axisStructures = [];
          }
          if (element.modelId) {
            signalModels.set(element.signalId, element.modelId);
          }
        }
        return of(
          IntersectionActions.setTrafficLights({ trafficLights: list }),
          new fromSignals.SetSignalTypes(signalModels)
        );
      })
    )
  );

  fetchIntersections$ = createEffect(() =>
    this.intersectionService.getIntersectionActions().pipe(
      switchMap((data) => {
        const list: Intersection[] = JSON.parse(data);

        return of(IntersectionActions.setIntersections({ intersections: list }));
      })
    )
  );

  fetchIntersectionSwitchings$ = createEffect(() =>
    this.intersectionService.getSwitchingActions().pipe(
      switchMap((data) => {
        const list: IntersectionSwitching[] = JSON.parse(data);

        return of(IntersectionActions.setSwitchings({ switchings: list }));
      })
    )
  );

  intersectionLanesActions$ = createEffect(() =>
    this.intersectionService.getLaneActions().pipe(
      switchMap((data) => {
        const list: IntersectionLane[] = JSON.parse(data);

        return of(IntersectionActions.setLanes({ lanes: list }));
      })
    )
  );

  luaModuleSettingsReceivedAction$ = createEffect(() =>
    this.intersectionService.getLuaSettingsReceivedActions().pipe(
      switchMap((data) => {
        const list: LuaSetting<any>[] = JSON.parse(data);
        const settings = new LuaSettings('Kreuzungen', list);

        return of(IntersectionActions.setModuleSettings({ settings }));
      })
    )
  );

  // effect will not dispatch any actions
  changeSettingCommand$ = createEffect(
    () =>
      this.actions$.pipe(
        ofType(IntersectionActions.changeModuleSettings),
        map((action) => {
          this.intersectionService.changeModuleSettings(action.setting, action.value);
        })
      ),
    { dispatch: false }
  );

  // effect will not dispatch any actions
  switchManuallyCommand$ = createEffect(
    () =>
      this.actions$.pipe(
        ofType(IntersectionActions.switchManually),
        map((action) => {
          this.intersectionService.switchManually(action.intersection.name, action.switching.name);
        })
      ),
    { dispatch: false }
  );

  // effect will not dispatch any actions
  switchAutomaticallyCommand$ = createEffect(
    () =>
      this.actions$.pipe(
        ofType(IntersectionActions.switchAutomatically),
        map((action) => {
          this.intersectionService.switchAutomatically(action.intersection.name);
        })
      ),
    { dispatch: false }
  );

  // effect will not dispatch any actions
  switchToStaticCamCommand$ = createEffect(
    () =>
      this.actions$.pipe(
        ofType(IntersectionActions.switchToStaticCam),
        map((action) => {
          this.intersectionService.changeStaticCam(action.staticCam);
        })
      ),
    { dispatch: false }
  );

  constructor(
    private actions$: Actions,
    private httpClient: HttpClient,
    private router: Router,
    private intersectionService: IntersectionService
  ) {}
}
