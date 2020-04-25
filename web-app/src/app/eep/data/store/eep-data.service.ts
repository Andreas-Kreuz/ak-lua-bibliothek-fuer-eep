import { Injectable } from '@angular/core';
import { Store } from '@ngrx/store';
import { Observable } from 'rxjs';

import * as fromRoot from '../../../app.reducers';
import { WsEvent } from '../../../core/socket/ws-event';
import { WsService } from '../../../core/socket/ws.service';

@Injectable({
  providedIn: 'root'
})
export class EepDataService {
  private dataActions$: Observable<WsEvent>;
  private freeDataActions$: Observable<WsEvent>;

  constructor(private socket: WsService,
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
