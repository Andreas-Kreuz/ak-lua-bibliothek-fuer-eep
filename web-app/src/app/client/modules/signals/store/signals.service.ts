import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { SocketService } from '../../../../core/socket/socket-service';
import { ApiDataRoom } from 'web-shared/build/rooms';

@Injectable()
export class SignalsService {
  private signals$: Observable<string>;
  private signalTypes$: Observable<string>;

  constructor(private socket: SocketService) {}

  getSignalActions(): Observable<string> {
    if (!this.signals$) {
      this.signals$ = this.socket.listenToData(ApiDataRoom, 'signals');
    }
    return this.signals$;
  }

  getSignalTypeDefinitionActions(): Observable<string> {
    if (!this.signalTypes$) {
      this.signalTypes$ = this.socket.listenToData(ApiDataRoom, 'signal-type-definitions');
    }
    return this.signalTypes$;
  }
}
