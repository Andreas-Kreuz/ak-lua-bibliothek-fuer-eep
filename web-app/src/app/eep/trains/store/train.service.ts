import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { WsEvent } from '../../../core/socket/ws-event';
import { WsService } from '../../../core/socket/ws.service';

@Injectable({
  providedIn: 'root'
})
export class TrainService {

  constructor(private wsService: WsService) {
  }

  private railTrains$: Observable<WsEvent>;
  private railRollingStock$: Observable<WsEvent>;
  private roadTrains$: Observable<WsEvent>;
  private roadRollingStock$: Observable<WsEvent>;
  private tramTrains$: Observable<WsEvent>;
  private tramRollingStock$: Observable<WsEvent>;


  railTrainsActions$(): Observable<WsEvent> {
    if (!this.railTrains$) {
      this.railTrains$ = this.wsService.listen('[Data-rail-trains]');
    }
    return this.railTrains$;
  }

  railRollingStockActions$(): Observable<WsEvent> {
    if (!this.railRollingStock$) {
      this.railRollingStock$ = this.wsService.listen('[Data-rail-rolling-stocks]');
    }
    return this.railRollingStock$;
  }

  roadTrainsActions$(): Observable<WsEvent> {
    if (!this.roadTrains$) {
      this.roadTrains$ = this.wsService.listen('[Data-road-trains]');
    }
    return this.roadTrains$;
  }

  roadRollingStockActions$(): Observable<WsEvent> {
    if (!this.roadRollingStock$) {
      this.roadRollingStock$ = this.wsService.listen('[Data-road-rolling-stocks]');
    }
    return this.roadRollingStock$;
  }

  tramTrainsActions$(): Observable<WsEvent> {
    if (!this.tramTrains$) {
      this.tramTrains$ = this.wsService.listen('[Data-tram-trains]');
    }
    return this.tramTrains$;
  }

  tramRollingStockActions$(): Observable<WsEvent> {
    if (!this.tramRollingStock$) {
      this.tramRollingStock$ = this.wsService.listen('[Data-tram-rolling-stocks]');
    }
    return this.tramRollingStock$;
  }

  emit(wsEvent: WsEvent) {
    return this.wsService.emit(wsEvent);
  }
}
