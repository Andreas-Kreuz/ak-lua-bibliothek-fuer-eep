import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import * as fromDataTypes from './data-types.actions';
import { SocketEvent } from '../../socket/socket-event';
import { SocketService } from '../../socket/socket-service';

@Injectable({
  providedIn: 'root',
})
export class DataTypesService {
  private actionObservable: Observable<SocketEvent>;

  constructor(private socketService: SocketService) {}

  getActions(): Observable<SocketEvent> {
    if (!this.actionObservable) {
      this.actionObservable = this.socketService.listen(fromDataTypes.ROOM);
    }
    return this.actionObservable;
  }
}
