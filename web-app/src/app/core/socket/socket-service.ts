import { Injectable } from '@angular/core';
import { SocketEvent } from './socket-event';
import { environment } from '../../../environments/environment';
import { Store } from '@ngrx/store';
import * as fromRoot from '../../app.reducers';
import { Observable, of, BehaviorSubject } from 'rxjs';
import { io, Socket } from 'socket.io-client';
import { RoomEvent } from 'web-shared';
import * as CoreAction from '../store/core.actions';

@Injectable({
  providedIn: 'root',
})
export class SocketService {
  connected$ = new BehaviorSubject<boolean>(false);
  private socket: Socket;

  constructor(private store: Store<fromRoot.State>) {
    this.socket = io(location.hostname + ':' + environment.websocketPort, {});
    this.socket.on('connect', () => {
      this.connected$.next(true);
      this.store.dispatch(CoreAction.connectedToServer());
    });
    this.socket.on('disconnect', () => {
      this.connected$.next(false);
      this.store.dispatch(CoreAction.disconnectedFromServer());
    });
    this.socket.connect();
  }

  join(room: string) {
    // auto rejoin after reconnect mechanism
    console.log('----- JOINING ROOM    ----- ' + room);
    this.connected$.subscribe((connected) => {
      if (connected) {
        this.socket.emit(RoomEvent.JoinRoom, { room });
      }
    });
  }

  leave(room: string) {
    console.log('----- LEAVING ROOM    ----- ' + room);
    this.socket.emit(RoomEvent.LeaveRoom, { room });
  }

  disconnect() {
    this.socket.disconnect();
    console.warn('----- SOCKET DISCONNECTED ----- ');
    this.connected$.next(false);
  }

  emit(event: string, data?: any) {
    console.groupCollapsed('----- SOCKET OUTGOING ----- ' + event);
    console.log('Action: ', event);
    console.log('Payload: ', data);
    console.groupEnd();

    this.socket.emit(event, data);
  }

  listen(event: string): Observable<any> {
    return new Observable((observer) => {
      this.socket.on(event, (data: any) => {
        console.groupCollapsed('----- SOCKET INBOUND  ----- ' + event);
        console.log('Action      : ', event);
        if (data) {
          if ('string' === typeof data) {
            console.log('PAYLOAD TYPE: STRING !!!');
          } else {
            console.log('Payload Type: ' + typeof data);
          }
        }
        console.log('Payload     : ', data);
        console.groupEnd();

        observer.next(data);
      });

      // dispose of the event listener when unsubscribed
      return () => this.socket.off(event);
    });
  }
}
