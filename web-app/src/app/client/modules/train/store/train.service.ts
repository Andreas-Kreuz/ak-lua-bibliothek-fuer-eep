import { Injectable, OnDestroy } from '@angular/core';
import { Store } from '@ngrx/store';
import { Subscription } from 'rxjs';
import * as fromTrain from '../store/train.reducer';
import { SocketService } from '../../../../core/socket/socket-service';
import * as TrainAction from './train.actions';
import { TrackType, Train, TrainListEntry } from 'web-shared/build/model/trains';
import { ApiDataRoom, TrainDetailsRoom, TrainListRoom } from 'web-shared/build/rooms';

@Injectable()
export class TrainService implements OnDestroy {
  trainListSub: Subscription;
  selectedTrainSub: Subscription;

  constructor(private socket: SocketService, private store: Store<fromTrain.State>) {
    console.log('##### Creating TrainService');
  }

  listenTo(trackType: string) {
    if (this.trainListSub) {
      this.trainListSub.unsubscribe();
    }
    const observer = this.socket.listenToData(TrainListRoom, trackType);
    this.trainListSub = observer.subscribe((data) => {
      const record: Record<string, TrainListEntry> = JSON.parse(data);
      const trainList = Object.values(record);
      this.store.dispatch(TrainAction.trainListUpdated({ trainList }));
    });
  }

  listenToTrain(trainId: string) {
    if (this.selectedTrainSub) {
      this.selectedTrainSub.unsubscribe();
    }
    const observer = this.socket.listenToData(TrainDetailsRoom, trainId);
    this.selectedTrainSub = observer.subscribe((data) => {
      const record: Record<string, TrainListEntry> = JSON.parse(data);
      const train = record as unknown as Train;
      this.store.dispatch(TrainAction.trainSelected({ train }));
    });
  }

  connect(): void {
    console.log('##### Connecting TrainService');
  }

  disconnect(): void {
    console.log('##### Disconnect TrainService');
    if (this.trainListSub) {
      this.trainListSub.unsubscribe();
      this.trainListSub = undefined;
    }
    if (this.selectedTrainSub) {
      this.selectedTrainSub.unsubscribe();
      this.selectedTrainSub = undefined;
    }
  }

  ngOnDestroy(): void {
    console.log('##### Destroying TrainService');
  }
}
