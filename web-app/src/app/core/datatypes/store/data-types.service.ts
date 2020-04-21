import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import * as fromDataTypes from './data-types.actions';
import { WsEvent } from '../../socket/ws-event';
import { WsService } from '../../socket/ws.service';

@Injectable({
  providedIn: 'root'
})
export class DataTypesService {
  private actionObservable: Observable<WsEvent>;

  constructor(private wsService: WsService) {
  }

  getActions(): Observable<WsEvent> {
    if (!this.actionObservable) {
      this.actionObservable = this.wsService.listen(fromDataTypes.ROOM);
    }
    return this.actionObservable;
  }
}
