import { Injectable } from '@angular/core';
import { Actions, ofType, createEffect } from '@ngrx/effects';
import { map, switchMap } from 'rxjs/operators';
import * as IntersectionActions from './intersection.actions';
import { of } from 'rxjs';
import { IntersectionLane } from '../models/intersection-lane.model';
import * as fromSignals from '../../signals/store/signal.actions';
import { IntersectionTrafficLight } from '../models/intersection-traffic-light.model';
import { IntersectionService } from './intersection.service';
import { Intersection } from '../models/intersection.model';
import { IntersectionSwitching } from '../models/intersection-switching.model';
import { LuaSettings } from '../../../../shared/model/lua-settings';
import { LuaSetting } from '../../../../shared/model/lua-setting';

@Injectable()
export class IntersectionEffects {
  fetchIntersectionTrafficLights$ = createEffect(() =>
    this.intersectionService.getTrafficLightActions().pipe(
      switchMap((data) => {
        const record: Record<string, IntersectionTrafficLight> = JSON.parse(data);
        const list: IntersectionTrafficLight[] = Object.values(record);
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
        const record: Record<string, Intersection> = JSON.parse(data);
        const list: Intersection[] = Object.values(record);

        return of(IntersectionActions.setIntersections({ intersections: list }));
      })
    )
  );

  fetchIntersectionSwitchings$ = createEffect(() =>
    this.intersectionService.getSwitchingActions().pipe(
      switchMap((data) => {
        const record: Record<string, IntersectionSwitching> = JSON.parse(data);
        const list: IntersectionSwitching[] = Object.values(record);

        return of(IntersectionActions.setSwitchings({ switchings: list }));
      })
    )
  );

  intersectionLanesActions$ = createEffect(() =>
    this.intersectionService.getLaneActions().pipe(
      switchMap((data) => {
        const record: Record<string, IntersectionLane> = JSON.parse(data);
        const list: IntersectionLane[] = Object.values(record);

        return of(IntersectionActions.setLanes({ lanes: list }));
      })
    )
  );

  luaModuleSettingsReceivedAction$ = createEffect(() =>
    this.intersectionService.getLuaSettingsReceivedActions().pipe(
      switchMap((data) => {
        const record: Record<string, LuaSetting<any>> = JSON.parse(data);
        const list: LuaSetting<any>[] = Object.values(record);
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

  constructor(private actions$: Actions, private intersectionService: IntersectionService) {}
}
