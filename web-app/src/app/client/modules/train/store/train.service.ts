import { Injectable, OnDestroy } from '@angular/core';
import { Observable } from 'rxjs';

import { SocketService } from '../../../../core/socket/socket-service';

@Injectable()
export class TrainService implements OnDestroy {
  public railTrains$ = this.socket.listenToData('trains');
  public railRollingStock$ = this.socket.listenToData('rolling-stocks');

  constructor(private socket: SocketService) {
    console.log('##### Creating TrainService');
  }

  ngOnDestroy(): void {
    console.log('##### Destroying TrainService');
  }
}
