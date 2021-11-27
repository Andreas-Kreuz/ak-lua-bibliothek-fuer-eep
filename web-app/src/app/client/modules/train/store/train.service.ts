import { Injectable, OnDestroy } from '@angular/core';
import { Store } from '@ngrx/store';
import { Subscription } from 'rxjs';
import * as fromTrain from '../store/train.reducer';
import { SocketService } from '../../../../core/socket/socket-service';
import * as TrainAction from './train.actions';

@Injectable()
export class TrainService implements OnDestroy {
  trainSub: Subscription;
  rollingStockSub: Subscription;

  constructor(private socket: SocketService, private store: Store<fromTrain.State>) {
    console.log('##### Creating TrainService');
  }

  connect(): void {
    console.log('##### Connecting TrainService');
    if (!this.trainSub) {
      const train = this.socket.listenToData('trains');
      this.trainSub = train.subscribe((data) => {
        this.store.dispatch(TrainAction.trainsUpdated({ json: data }));
      });
    }
    if (!this.rollingStockSub) {
      const rollingStock = this.socket.listenToData('rolling-stocks');
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
  }

  ngOnDestroy(): void {
    console.log('##### Destroying TrainService');
  }
}
