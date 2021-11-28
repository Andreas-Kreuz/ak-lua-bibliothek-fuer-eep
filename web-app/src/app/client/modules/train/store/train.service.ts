import { Injectable, OnDestroy } from '@angular/core';
import { Store } from '@ngrx/store';
import { Subscription } from 'rxjs';
import * as fromTrain from '../store/train.reducer';
import { SocketService } from '../../../../core/socket/socket-service';
import * as TrainAction from './train.actions';
import { TrackType, TrainListEntry } from 'web-shared/build/model/trains';
import { ApiDataRoom, TrainListRoom } from 'web-shared/build/rooms';

@Injectable()
export class TrainService implements OnDestroy {
  trainListSub: Subscription;
  trainSub: Subscription;
  rollingStockSub: Subscription;

  constructor(private socket: SocketService, private store: Store<fromTrain.State>) {
    console.log('##### Creating TrainService');
  }

  listenTo(trackType: string) {
    if (this.trainListSub) {
      this.trainListSub.unsubscribe();
    }
    console.log(TrainListRoom);
    const trainListObs = this.socket.listenToData(TrainListRoom, trackType);
    this.trainListSub = trainListObs.subscribe((data) => {
      const record: Record<string, TrainListEntry> = JSON.parse(data);
      const trainList = Object.values(record);
      this.store.dispatch(TrainAction.trainListUpdated({ trainList }));
    });
  }

  connect(): void {
    console.log('##### Connecting TrainService');
    if (!this.trainSub) {
      const train = this.socket.listenToData(ApiDataRoom, 'trains');
      this.trainSub = train.subscribe((data) => {
        this.store.dispatch(TrainAction.trainsUpdated({ json: data }));
      });
    }
    if (!this.rollingStockSub) {
      const rollingStock = this.socket.listenToData(ApiDataRoom, 'rolling-stocks');
      this.rollingStockSub = rollingStock.subscribe((data) => {
        this.store.dispatch(TrainAction.rollingStockUpdated({ json: data }));
      });
    }
  }

  disconnect(): void {
    console.log('##### Disconnect TrainService');
    if (this.trainSub) {
      this.trainSub.unsubscribe();
      this.trainSub = undefined;
    }
    if (this.rollingStockSub) {
      this.rollingStockSub.unsubscribe();
      this.rollingStockSub = undefined;
    }
    if (this.trainListSub) {
      this.trainListSub.unsubscribe();
      this.trainListSub = undefined;
    }
  }

  ngOnDestroy(): void {
    console.log('##### Destroying TrainService');
  }
}
