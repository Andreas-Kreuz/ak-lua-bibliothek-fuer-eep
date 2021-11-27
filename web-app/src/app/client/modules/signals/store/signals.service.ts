import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { SocketEvent } from '../../../../core/socket/socket-event';
import { SocketService } from '../../../../core/socket/socket-service';
import { DataEvent } from 'web-shared';

@Injectable()
export class SignalsService {
  private signals$: Observable<string>;
  private signalTypes$: Observable<string>;

  constructor(private socket: SocketService) {}

  getSignalActions(): Observable<string> {
    if (!this.signals$) {
      this.signals$ = this.socket.listenToData('signals');
    }
    return this.signals$;
  }

  getSignalTypeDefinitionActions(): Observable<string> {
    if (!this.signalTypes$) {
      this.signalTypes$ = this.socket.listenToData('signal-type-definitions');
    }
    return this.signalTypes$;
  }
}
