import { Injectable } from '@angular/core';
import { Store } from '@ngrx/store';
import { Subscription } from 'rxjs';

import * as fromRoot from '../../../app.reducers';
import { WsEvent } from '../../../core/socket/ws-event';
import { WsService } from '../../../core/socket/ws.service';
import { DataType } from '../model/data-type';
import * as fromGenericData from './generic-data.actions';

@Injectable({
  providedIn: 'root'
})
export class GenericDataService {
  private wsSubscription: Subscription;

  constructor(private socket: WsService,
              private store: Store<fromRoot.State>) {
  }

  connect() {
    this.wsSubscription = this.socket
      .listen('[Data-api-entries]')
      .subscribe(
        (wsEvent: WsEvent) => {
          if (wsEvent.action === 'Set') {
            const dataTypes: DataType[] = JSON.parse(wsEvent.payload);
            dataTypes.sort((a: DataType, b: DataType) => {
              return a.name.localeCompare(b.name);
            });
            this.store.dispatch(new fromGenericData.SetDataTypes(dataTypes));
          }
        },
        error => {
          console.log(error);
        },
        () => console.log('Closed socket: GenericDataService')
      );
  }

  disconnect() {
    this.wsSubscription.unsubscribe();
  }
}
