import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { WsEvent } from '../../../core/socket/ws-event';
import { WsService } from '../../../core/socket/ws.service';

@Injectable({
  providedIn: 'root'
})
export class IntersectionService {

  constructor(private wsService: WsService) {
  }

  private intersectionActions$: Observable<WsEvent>;
  private laneActions$: Observable<WsEvent>;
  private switchingActions$: Observable<WsEvent>;
  private trafficLightActions$: Observable<WsEvent>;

  getIntersectionActions(): Observable<WsEvent> {
    if (!this.intersectionActions$) {
      this.intersectionActions$ = this.wsService.listen('[Data-intersections]');
    }
    return this.intersectionActions$;
  }

  getLaneActions(): Observable<WsEvent> {
    if (!this.laneActions$) {
      this.laneActions$ = this.wsService.listen('[Data-intersection-lanes]');
    }
    return this.laneActions$;
  }

  getSwitchingActions(): Observable<WsEvent> {
    if (!this.switchingActions$) {
      this.switchingActions$ = this.wsService.listen('[Data-intersection-switchings]');
    }
    return this.switchingActions$;
  }

  getTrafficLightActions(): Observable<WsEvent> {
    if (!this.trafficLightActions$) {
      this.trafficLightActions$ = this.wsService.listen('[Data-intersection-traffic-lights]');
    }
    return this.trafficLightActions$;
  }

  emit(wsEvent: WsEvent) {
    return this.wsService.emit(wsEvent);
  }
}
