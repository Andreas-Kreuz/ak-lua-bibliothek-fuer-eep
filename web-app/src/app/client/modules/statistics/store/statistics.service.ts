import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { SocketService } from '../../../../core/socket/socket-service';

@Injectable({
  providedIn: 'root',
})
export default class StatisticsService {
  private serverCollectorStats$: Observable<string>;

  constructor(private socket: SocketService) {}

  getServerCollectorStats(): Observable<string> {
    if (!this.serverCollectorStats$) {
      this.serverCollectorStats$ = this.socket.listenToData('runtime');
    }
    return this.serverCollectorStats$;
  }
}
