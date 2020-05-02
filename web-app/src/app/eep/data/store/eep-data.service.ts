import { Injectable } from '@angular/core';
import { Store } from '@ngrx/store';
import { Observable } from 'rxjs';

import * as fromRoot from '../../../app.reducers';
import { SocketEvent } from '../../../core/socket/socket-event';
import { SocketService } from '../../../core/socket/socket-service';

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
      this.dataActions$ = this.socket.listen('[Data-save-slots]');
    }
    return this.dataActions$;
  }

  getFreeDataActions() {
    if (!this.freeDataActions$) {
      this.freeDataActions$ = this.socket.listen('[Data-free-slots]');
    }
    return this.freeDataActions$;
  }
}
