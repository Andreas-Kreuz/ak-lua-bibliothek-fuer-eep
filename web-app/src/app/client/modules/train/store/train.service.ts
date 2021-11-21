import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { SocketEvent } from '../../../../core/socket/socket-event';
import { SocketService } from '../../../../core/socket/socket-service';
import { DataEvent } from 'web-shared';

@Injectable()
export class TrainService {
  private railTrains$: Observable<string>;
  private railRollingStock$: Observable<string>;

  constructor(private socket: SocketService) {}

  trainsActions$(): Observable<string> {
    if (!this.railTrains$) {
      this.railTrains$ = this.socket.listen(DataEvent.eventOf('trains'));
      this.socket.join(DataEvent.roomOf('trains'));
    }
    return this.railTrains$;
  }

  rollingStockActions$(): Observable<string> {
    if (!this.railRollingStock$) {
      this.railRollingStock$ = this.socket.listen(DataEvent.eventOf('rolling-stocks'));
      this.socket.join(DataEvent.roomOf('rolling-stocks'));
    }
    return this.railRollingStock$;
  }

  disconnect(): void {
    if (this.railTrains$) {
      this.socket.leave(DataEvent.eventOf('trains'));
      this.railTrains$ = undefined;
    }

    if (this.railRollingStock$) {
      this.socket.leave(DataEvent.roomOf('rolling-stocks'));
      this.railRollingStock$ = undefined;
    }
  }
}
