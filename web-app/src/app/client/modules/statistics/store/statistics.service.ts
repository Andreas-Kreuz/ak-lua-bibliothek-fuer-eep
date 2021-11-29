import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { SocketService } from '../../../../core/socket/socket-service';
import { ApiDataRoom } from 'web-shared/build/rooms';

@Injectable({
  providedIn: 'root',
})
export default class StatisticsService {
  private serverCollectorStats$: Observable<string>;

  constructor(private socket: SocketService) {}

  getServerCollectorStats(): Observable<string> {
    if (!this.serverCollectorStats$) {
      this.serverCollectorStats$ = this.socket.listenToData(ApiDataRoom, 'runtime');
    }
    return this.serverCollectorStats$;
  }
}
