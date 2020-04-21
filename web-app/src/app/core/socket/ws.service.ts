import { Injectable } from '@angular/core';
import { WsEvent } from './ws-event';
import { environment } from '../../../environments/environment';
import { webSocket, WebSocketSubject } from 'rxjs/webSocket';
import { Store } from '@ngrx/store';
import * as fromRoot from '../../app.reducers';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class WsService {
  public websocketSubject: WebSocketSubject<WsEvent>;
  private readonly url: string;

  constructor(private store: Store<fromRoot.State>) {
    this.url = 'ws://' + location.hostname
      + ':'
      + environment.websocketPort
      + environment.websocketPath;
    this.connect();
  }

  public connect() {
    if (!this.websocketSubject) {
      console.log('Connecting websocket: ' + this.url);
      // this.websocket = new WebSocket(this.url);
      this.websocketSubject = webSocket(this.url);
      this.websocketSubject.subscribe(
        (wsEvent: WsEvent) => {
          this.logSocket('INBOUND ', wsEvent);
        },
        (err) => {
          console.log(err);
        },
        () => console.log('Websocket is complete')
      );
    }
    return this;
  }

  public disconnect() {
    if (this.websocketSubject) {
      this.websocketSubject.complete();
    }
  }

  public listen(room: string, action?: string): Observable<WsEvent> {
    return this.websocketSubject.multiplex(
      () => {
        const event = new WsEvent('[Room]', 'Subscribe', room);
        this.logSocket('OUTGOING', event, room);
        return event;
      },
      () => {
        const event = new WsEvent('[Room]', 'Unsubscribe', room);
        this.logSocket('OUTGOING', event, room);
        return event;
      },
      (wsEvent: WsEvent) => {
        if (action) {
          return wsEvent.room === room && wsEvent.action === action;
        }
        return wsEvent.room === room;
      }
    );
  }

  private logSocket(direction: string, wsEvent: WsEvent, additionalInfo?: string) {
    if (wsEvent.room === '[Ping]') {
      return;
    }

    console.groupCollapsed(direction + ' SOCKET: '
      + wsEvent.room + ' ' + wsEvent.action
      + (additionalInfo ? ' ' + additionalInfo : '')
    );
    console.log('Room: ', wsEvent.room);
    console.log('Action: ', wsEvent.action);
    console.log('Event: ', wsEvent);
    console.groupEnd();
  }

  public emit(wsEvent: WsEvent) {
    this.logSocket('OUTGOING', wsEvent);
    this.websocketSubject.next(wsEvent);
  }
}
