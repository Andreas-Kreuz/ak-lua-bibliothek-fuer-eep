import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { SocketEvent } from '../../../core/socket/socket-event';
import { SocketService } from '../../../core/socket/socket-service';

@Injectable({
  providedIn: 'root'
})
export class SignalsService {

  constructor(private wsService: SocketService) {
  }

  private signals$: Observable<SocketEvent>;
  private signalTypes$: Observable<SocketEvent>;

  getSignalActions(): Observable<SocketEvent> {
    if (!this.signals$) {
      this.signals$ = this.wsService.listen('[Data-signals]');
    }
    return this.signals$;
  }

  getSignalTypeDefinitionActions(): Observable<SocketEvent> {
    if (!this.signalTypes$) {
      this.signalTypes$ = this.wsService.listen('[Data-signal-type-definitions]');
    }
    return this.signalTypes$;
  }

  emit(wsEvent: SocketEvent) {
    return this.wsService.emit(wsEvent.action, wsEvent.payload);
  }
}
