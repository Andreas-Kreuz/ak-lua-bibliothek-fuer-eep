import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { Actions, Effect, ofType } from '@ngrx/effects';
import { map, switchMap } from 'rxjs/operators';
import * as fromIntersections from './intersection.actions';
import { of } from 'rxjs';
import { IntersectionLane } from '../models/intersection-lane.model';
import * as fromSignals from '../../signals/store/signal.actions';
import { IntersectionTrafficLight } from '../models/intersection-traffic-light.model';
import { IntersectionService } from './intersection.service';
import { WsEvent } from '../../../core/socket/ws-event';
import { Intersection } from '../models/intersection.model';
import { IntersectionSwitching } from '../models/intersection-switching.model';

@Injectable()
export class IntersectionEffects {
  @Effect()
  fetchIntersectionTrafficLights$ = this.intersectionService.getTrafficLightActions()
    .pipe(
      switchMap(
        (wsEvent: WsEvent) => {
          const list: IntersectionTrafficLight[] = JSON.parse(wsEvent.payload);
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
            new fromIntersections.SetIntersectionTrafficLights(list),
            new fromSignals.SetSignalTypes(signalModels),
          );
        }
      )
    );

  @Effect()
  fetchIntersections$ = this.intersectionService.getIntersectionActions()
    .pipe(
      switchMap(
        (wsEvent: WsEvent) => {
          const list: Intersection[] = JSON.parse(wsEvent.payload);

          return of(
            new fromIntersections.SetIntersections(list),
          );
        }
      )
    );

  @Effect()
  fetchIntersectionSwitchings$ = this.intersectionService.getSwitchingActions()
    .pipe(
      switchMap(
        (wsEvent: WsEvent) => {
          const list: IntersectionSwitching[] = JSON.parse(wsEvent.payload);

          return of(
            new fromIntersections.SetIntersectionSwitching(list),
          );
        }
      )
    );

  @Effect()
  intersectionLanesActions$ = this.intersectionService.getLaneActions()
    .pipe(
      switchMap(
        (wsEvent: WsEvent) => {
          const list: IntersectionLane[] = JSON.parse(wsEvent.payload);

          return of(
            new fromIntersections.SetIntersectionLanes(list),
          );
        }
      )
    );

  @Effect({dispatch: false}) // effect will not dispatch any actions
  switchManuallyCommand$ = this.actions$.pipe(
    ofType(fromIntersections.SWITCH_MANUALLY),
    map((action: fromIntersections.SwitchManually) => {
      const command = 'AkKreuzungSchalteManuell|'
        + action.payload.intersection.name + '|'
        + action.payload.switching.name;
      this.intersectionService.emit(
        new WsEvent('[EEPCommand]', 'Send', command));
    })
  );

  @Effect({dispatch: false}) // effect will not dispatch any actions
  switchAutomaticallyCommand$ = this.actions$.pipe(
    ofType(fromIntersections.SWITCH_AUTOMATICALLY),
    map((action: fromIntersections.SwitchAutomatically) => {
      const command = 'AkKreuzungSchalteAutomatisch|'
        + action.payload.intersection.name;
      this.intersectionService.emit(
        new WsEvent('[EEPCommand]', 'Send', command));
    })
  );

  @Effect({dispatch: false}) // effect will not dispatch any actions
  switchToCamCommand$ = this.actions$.pipe(
    ofType(fromIntersections.SWITCH_TO_CAM),
    map((action: fromIntersections.SwitchToCam) => {
      const command = 'EEPSetCamera|0|' + action.payload.staticCam;
      this.intersectionService.emit(
        new WsEvent('[EEPCommand]', 'Send', command));
    })
  );

  constructor(private actions$: Actions,
              private httpClient: HttpClient,
              private router: Router,
              private intersectionService: IntersectionService) {
  }
}
