import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { SocketService } from '../socket/socket-service';
import { DataEvent } from 'web-shared';

@Injectable({
  providedIn: 'root',
})
export class CoreService {
  modulesChanged$: Observable<any>;
  versionChanged$: Observable<any>;

  constructor(private socket: SocketService) {
    // Every socket NOTES event has it's own observable, will be used by ngrx effects
    this.modulesChanged$ = this.socket.listen(DataEvent.eventOf('modules'));
    this.socket.join(DataEvent.roomOf('modules'));

    this.versionChanged$ = this.socket.listen(DataEvent.eventOf('eep-version'));
    this.socket.join(DataEvent.roomOf('eep-version'));
  }
}
