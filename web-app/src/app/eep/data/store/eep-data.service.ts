import { Injectable } from '@angular/core';
import { Store } from '@ngrx/store';
import { Observable } from 'rxjs';

import * as fromRoot from '../../../app.reducers';
import { SocketEvent } from '../../../core/socket/socket-event';
import { SocketService } from '../../../core/socket/socket-service';
import { DataEvent } from 'web-shared';

@Injectable({
  providedIn: 'root'
})
export class EepDataService {
  private dataActions$: Observable<SocketEvent>;
  private freeDataActions$: Observable<SocketEvent>;

  constructor(private socket: SocketService,
              private store: Store<fromRoot.State>) {
  }

  getDataActions() {
    if (!this.dataActions$) {
      this.dataActions$ = this.socket.listen(DataEvent.eventOf('save-slots'));
      this.socket.join(DataEvent.roomOf('save-slots'));
    }
    return this.dataActions$;
  }

  getFreeDataActions() {
    if (!this.freeDataActions$) {
      this.freeDataActions$ = this.socket.listen(DataEvent.eventOf('free-slots'));
      this.socket.join(DataEvent.roomOf('free-slots'));
    }
    return this.freeDataActions$;
  }
}
