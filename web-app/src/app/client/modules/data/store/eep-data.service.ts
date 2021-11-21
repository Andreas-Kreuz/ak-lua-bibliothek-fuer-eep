import { Injectable, OnDestroy } from '@angular/core';
import { Store } from '@ngrx/store';
import { Observable, Subscription } from 'rxjs';
import * as fromEep from './eep-data.reducers';
import { SocketService } from '../../../../core/socket/socket-service';
import { DataEvent } from 'web-shared';

@Injectable()
export class EepDataService {
  private dataActions$: Observable<string>;
  private freeDataActions$: Observable<string>;

  constructor(private socket: SocketService, private store: Store<fromEep.State>) {}

  getDataActions() {
    if (!this.dataActions$) {
      this.socket.join(DataEvent.roomOf('save-slots'));
      this.dataActions$ = this.socket.listen(DataEvent.eventOf('save-slots'));
    }
    return this.dataActions$;
  }

  getFreeDataActions() {
    if (!this.freeDataActions$) {
      this.socket.join(DataEvent.roomOf('free-slots'));
      this.freeDataActions$ = this.socket.listen(DataEvent.eventOf('free-slots'));
    }
    return this.freeDataActions$;
  }

  disconnect() {
    if (this.dataActions$) {
      this.socket.leave(DataEvent.roomOf('save-slots'));
    }
    if (this.freeDataActions$) {
      this.socket.leave(DataEvent.roomOf('free-slots'));
    }
  }
}
