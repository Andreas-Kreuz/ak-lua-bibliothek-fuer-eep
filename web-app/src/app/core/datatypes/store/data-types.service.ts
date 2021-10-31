import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { SocketEvent } from '../../socket/socket-event';
import { SocketService } from '../../socket/socket-service';

@Injectable({
  providedIn: 'root',
})
export class DataTypesService {
  logLinesCleared$: Observable<any>;

  private actionObservable: Observable<SocketEvent>;

  constructor(private socketService: SocketService) {
    this.logLinesCleared$ = this.socketService.listen('NULL');
    this.socketService.join('NULL');
  }
}
