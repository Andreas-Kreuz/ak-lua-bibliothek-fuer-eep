import { Injectable } from '@angular/core';
import { Store } from '@ngrx/store';
import { Subscription } from 'rxjs';

import * as fromRoot from '../../app.reducers';
import { WsEvent } from './ws-event';
import { WsEventUtil } from './ws-event-util';
import { WsService } from './ws.service';

@Injectable({
  providedIn: 'root'
})
export class PongService {
  private wsSubscription: Subscription;

  constructor(private socket: WsService,
              private store: Store<fromRoot.State>) {
  }

  connect() {
    const mpSocket = this.socket.listen('[Ping]');
    this.wsSubscription = mpSocket.subscribe(
      (wsEvent: WsEvent) => {
        if (WsEventUtil.storeAction(wsEvent) === '[Ping] Ping') {
          this.sendPong(wsEvent.payload);
        }
      },
      error => {
        console.log(error);
      },
      () => console.log('Closed socket: PongService')
    );
  }

  private sendPong(message: string) {
    this.socket.emit(new WsEvent('[Ping]', 'Pong', 'pong ' + message));
  }
}
