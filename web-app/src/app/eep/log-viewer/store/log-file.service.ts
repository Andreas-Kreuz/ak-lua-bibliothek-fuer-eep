import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { WsEvent } from '../../../core/socket/ws-event';
import { WsService } from '../../../core/socket/ws.service';

@Injectable({
  providedIn: 'root'
})
export class LogFileService {

  constructor(private wsService: WsService) {
  }

  private actionObservable: Observable<WsEvent>;

  getActions(): Observable<WsEvent> {
    if (!this.actionObservable) {
      this.actionObservable = this.wsService.listen('[Log]');
    }
    return this.actionObservable;
  }

  emit(wsEvent: WsEvent) {
    return this.wsService.emit(wsEvent);
  }
}
