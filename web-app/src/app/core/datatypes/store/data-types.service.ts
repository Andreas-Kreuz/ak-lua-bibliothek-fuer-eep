import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { AvailableDataTypesEvent } from 'web-shared';
import { SocketEvent } from '../../socket/socket-event';
import { SocketService } from '../../socket/socket-service';

@Injectable({
  providedIn: 'root',
})
export class DataTypesService {
  private actionObservable: Observable<SocketEvent>;

  logLinesCleared$: Observable<any>;

  constructor(private socketService: SocketService) {
    this.logLinesCleared$ = this.socketService.listen(AvailableDataTypesEvent.Changed);
    this.socketService.join(AvailableDataTypesEvent.Room);
  }
}
