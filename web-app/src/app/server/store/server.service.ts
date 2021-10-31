import { Injectable } from '@angular/core';
import { SettingsEvent, ServerStatusEvent } from 'web-shared';
import { Observable } from 'rxjs';
import { SocketService } from '../../core/socket/socket-service';

@Injectable({
  providedIn: 'root',
})
export class ServerService {
  settingsDirOkReceived$: Observable<any>;
  settingsDirErrorReceived$: Observable<any>;
  urlsChanged$: Observable<any>;

  constructor(private socket: SocketService) {
    // Every socket NOTES event has it's own observable, will be used by ngrx effects
    this.settingsDirOkReceived$ = this.socket.listen(SettingsEvent.DirOk);
    this.settingsDirErrorReceived$ = this.socket.listen(SettingsEvent.DirError);
    this.socket.join(SettingsEvent.Room);

    this.urlsChanged$ = this.socket.listen(ServerStatusEvent.UrlsChanged);
    this.socket.join(ServerStatusEvent.Room);
  }

  changeDirectory(eepDir: string) {
    this.socket.emit(SettingsEvent.ChangeDir, eepDir);
  }
}
