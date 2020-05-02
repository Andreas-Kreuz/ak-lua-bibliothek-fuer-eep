import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { SocketEvent } from '../../../core/socket/socket-event';
import { SocketService } from '../../../core/socket/socket-service';
import { DataEvent } from 'web-shared';

@Injectable({
  providedIn: 'root',
})
export class TrainService {
  constructor(private socket: SocketService) {}

  private railTrains$: Observable<string>;
  private railRollingStock$: Observable<string>;
  private roadTrains$: Observable<string>;
  private roadRollingStock$: Observable<string>;
  private tramTrains$: Observable<string>;
  private tramRollingStock$: Observable<string>;

  railTrainsActions$(): Observable<string> {
    if (!this.railTrains$) {
      this.railTrains$ = this.socket.listen(DataEvent.eventOf('rail-trains'));
      this.socket.join(DataEvent.roomOf('rail-trains'));
    }
    return this.railTrains$;
  }

  railRollingStockActions$(): Observable<string> {
    if (!this.railRollingStock$) {
      this.railRollingStock$ = this.socket.listen(DataEvent.eventOf('rail-rolling-stocks'));
      this.socket.join(DataEvent.roomOf('rail-rolling-stocks'));
    }
    return this.railRollingStock$;
  }

  roadTrainsActions$(): Observable<string> {
    if (!this.roadTrains$) {
      this.roadTrains$ = this.socket.listen(DataEvent.eventOf('road-trains'));
      this.socket.join(DataEvent.roomOf('road-trains'));
    }
    return this.roadTrains$;
  }

  roadRollingStockActions$(): Observable<string> {
    if (!this.roadRollingStock$) {
      this.roadRollingStock$ = this.socket.listen(DataEvent.eventOf('road-rolling-stocks'));
      this.socket.join(DataEvent.roomOf('road-rolling-stocks'));
    }
    return this.roadRollingStock$;
  }

  tramTrainsActions$(): Observable<string> {
    if (!this.tramTrains$) {
      this.tramTrains$ = this.socket.listen(DataEvent.eventOf('tram-trains'));
      this.socket.join(DataEvent.roomOf('tram-trains'));
    }
    return this.tramTrains$;
  }

  tramRollingStockActions$(): Observable<string> {
    if (!this.tramRollingStock$) {
      this.tramRollingStock$ = this.socket.listen(DataEvent.eventOf('tram-rolling-stocks'));
      this.socket.join(DataEvent.roomOf('tram-rolling-stocks'));
    }
    return this.tramRollingStock$;
  }

  emit(wsEvent: SocketEvent) {
    return this.socket.emit(wsEvent.action, wsEvent.payload);
  }
}
