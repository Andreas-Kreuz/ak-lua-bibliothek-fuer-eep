import { Injectable } from '@angular/core';
import { Store } from '@ngrx/store';
import { Subscription } from 'rxjs';

import * as fromRoot from '../../../../app.reducers';
import { SocketEvent } from '../../../../core/socket/socket-event';
import { SocketService } from '../../../../core/socket/socket-service';
import { DataType } from 'web-shared';
import * as fromGenericData from './generic-data.actions';
import { DataEvent } from 'web-shared';

@Injectable({
  providedIn: 'root',
})
export class GenericDataService {
  private wsSubscription: Subscription;

  constructor(private socket: SocketService, private store: Store<fromRoot.State>) {}

  connect() {
    this.wsSubscription = this.socket.listenToData('api-entries').subscribe(
      (data) => {
        const record = JSON.parse(data);
        const dataTypes: DataType[] = Object.values(record);
        dataTypes.sort((a: DataType, b: DataType) => a.name.localeCompare(b.name));
        this.store.dispatch(fromGenericData.setDataTypes({ dataTypes }));
      },
      (error) => {
        console.log(error);
      },
      () => console.log('Closed socket: GenericDataService')
    );
  }

  disconnect() {
    this.wsSubscription.unsubscribe();
  }
}
