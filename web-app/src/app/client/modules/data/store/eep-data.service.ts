import { Injectable, OnDestroy } from '@angular/core';
import { Store } from '@ngrx/store';
import { Observable, Subscription } from 'rxjs';
import * as fromEep from './eep-data.reducers';
import { SocketService } from '../../../../core/socket/socket-service';
import { ApiDataRoom } from 'web-shared/build/rooms';

@Injectable()
export class EepDataService {
  private dataActions$: Observable<string>;
  private freeDataActions$: Observable<string>;

  constructor(private socket: SocketService, private store: Store<fromEep.State>) {}

  getDataActions() {
    if (!this.dataActions$) {
      this.dataActions$ = this.socket.listenToData(ApiDataRoom, 'save-slots');
    }
    return this.dataActions$;
  }

  getFreeDataActions() {
    if (!this.freeDataActions$) {
      this.freeDataActions$ = this.socket.listenToData(ApiDataRoom, 'free-slots');
    }
    return this.freeDataActions$;
  }

  disconnect() {}
}
