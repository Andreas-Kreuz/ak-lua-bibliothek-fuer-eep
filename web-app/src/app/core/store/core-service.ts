import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { SocketService } from '../socket/socket-service';
import { ApiDataRoom } from 'web-shared/build/rooms';

@Injectable({
  providedIn: 'root',
})
export class CoreService {
  modulesChanged$: Observable<any>;
  versionChanged$: Observable<any>;

  constructor(private socket: SocketService) {
    // Every socket NOTES event has it's own observable, will be used by ngrx effects
    this.modulesChanged$ = this.socket.listenToData(ApiDataRoom, 'modules');
    this.versionChanged$ = this.socket.listenToData(ApiDataRoom, 'eep-version');
  }
}
