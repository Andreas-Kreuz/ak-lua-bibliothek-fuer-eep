import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { SocketService } from '../../../../core/socket/socket-service';
import { LogEvent } from 'web-shared';

@Injectable({
  providedIn: 'root',
})
export class LogFileService {
  logLinesAdded$: Observable<string>;
  logLinesCleared$: Observable<void>;

  constructor(private socket: SocketService) {
    // Every socket NOTES event has it's own observable, will be used by ngrx effects
    this.logLinesAdded$ = this.socket.listenToEvent(LogEvent.LinesAdded);
    this.logLinesCleared$ = this.socket.listenToEvent(LogEvent.LinesCleared);
    this.socket.join(LogEvent.Room);
  }

  clearLog() {
    this.socket.emit(LogEvent.ClearLog);
  }

  sendTestMessage() {
    this.socket.emit(LogEvent.SendTestMessage);
  }
}
