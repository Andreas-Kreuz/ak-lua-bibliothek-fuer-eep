import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { SocketEvent } from '../../../core/socket/socket-event';
import { SocketService } from '../../../core/socket/socket-service';

@Injectable({
  providedIn: 'root'
})
export class TrainService {

  constructor(private wsService: SocketService) {
  }

  private railTrains$: Observable<SocketEvent>;
  private railRollingStock$: Observable<SocketEvent>;
  private roadTrains$: Observable<SocketEvent>;
  private roadRollingStock$: Observable<SocketEvent>;
  private tramTrains$: Observable<SocketEvent>;
  private tramRollingStock$: Observable<SocketEvent>;


  railTrainsActions$(): Observable<SocketEvent> {
    if (!this.railTrains$) {
      this.railTrains$ = this.wsService.listen('[Data-rail-trains]');
    }
    return this.railTrains$;
  }

  railRollingStockActions$(): Observable<SocketEvent> {
    if (!this.railRollingStock$) {
      this.railRollingStock$ = this.wsService.listen('[Data-rail-rolling-stocks]');
    }
    return this.railRollingStock$;
  }

  roadTrainsActions$(): Observable<SocketEvent> {
    if (!this.roadTrains$) {
      this.roadTrains$ = this.wsService.listen('[Data-road-trains]');
    }
    return this.roadTrains$;
  }

  roadRollingStockActions$(): Observable<SocketEvent> {
    if (!this.roadRollingStock$) {
      this.roadRollingStock$ = this.wsService.listen('[Data-road-rolling-stocks]');
    }
    return this.roadRollingStock$;
  }

  tramTrainsActions$(): Observable<SocketEvent> {
    if (!this.tramTrains$) {
      this.tramTrains$ = this.wsService.listen('[Data-tram-trains]');
    }
    return this.tramTrains$;
  }

  tramRollingStockActions$(): Observable<SocketEvent> {
    if (!this.tramRollingStock$) {
      this.tramRollingStock$ = this.wsService.listen('[Data-tram-rolling-stocks]');
    }
    return this.tramRollingStock$;
  }

  emit(wsEvent: SocketEvent) {
    return this.wsService.emit(wsEvent.action, wsEvent.payload);
  }
}
