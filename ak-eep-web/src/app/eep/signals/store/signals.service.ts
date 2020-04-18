import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { WsEvent } from '../../../core/socket/ws-event';
import { WsService } from '../../../core/socket/ws.service';

@Injectable({
  providedIn: 'root'
})
export class SignalsService {

  constructor(private wsService: WsService) {
  }

  private signals$: Observable<WsEvent>;
  private signalTypes$: Observable<WsEvent>;

  getSignalActions(): Observable<WsEvent> {
    if (!this.signals$) {
      this.signals$ = this.wsService.listen('[Data-signals]');
    }
    return this.signals$;
  }

  getSignalTypeDefinitionActions(): Observable<WsEvent> {
    if (!this.signalTypes$) {
      this.signalTypes$ = this.wsService.listen('[Data-signal-type-definitions]');
    }
    return this.signalTypes$;
  }

  emit(wsEvent: WsEvent) {
    return this.wsService.emit(wsEvent);
  }
}
