import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { SocketEvent } from '../../../core/socket/socket-event';
import { SocketService } from '../../../core/socket/socket-service';

@Injectable({
  providedIn: 'root'
})
export class IntersectionService {

  constructor(private wsService: SocketService) {
  }

  private intersectionActions$: Observable<SocketEvent>;
  private laneActions$: Observable<SocketEvent>;
  private switchingActions$: Observable<SocketEvent>;
  private trafficLightActions$: Observable<SocketEvent>;
  private luaModuleSettingsActions$: Observable<SocketEvent>;

  getIntersectionActions(): Observable<SocketEvent> {
    if (!this.intersectionActions$) {
      this.intersectionActions$ = this.wsService.listen('[Data-intersections]');
    }
    return this.intersectionActions$;
  }

  getLaneActions(): Observable<SocketEvent> {
    if (!this.laneActions$) {
      this.laneActions$ = this.wsService.listen('[Data-intersection-lanes]');
    }
    return this.laneActions$;
  }

  getSwitchingActions(): Observable<SocketEvent> {
    if (!this.switchingActions$) {
      this.switchingActions$ = this.wsService.listen('[Data-intersection-switchings]');
    }
    return this.switchingActions$;
  }

  getTrafficLightActions(): Observable<SocketEvent> {
    if (!this.trafficLightActions$) {
      this.trafficLightActions$ = this.wsService.listen('[Data-intersection-traffic-lights]');
    }
    return this.trafficLightActions$;
  }

  getLuaSettingsReceivedActions(): Observable<SocketEvent> {
    if (!this.luaModuleSettingsActions$) {
      this.luaModuleSettingsActions$ = this.wsService.listen('[Data-intersection-module-settings]');
    }
    return this.luaModuleSettingsActions$;
  }

  emit(wsEvent: SocketEvent) {
    return this.wsService.emit(wsEvent.action, wsEvent.payload);
  }
}
