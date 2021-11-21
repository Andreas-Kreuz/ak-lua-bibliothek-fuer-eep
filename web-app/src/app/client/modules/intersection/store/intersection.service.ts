import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

import { SocketEvent } from '../../../../core/socket/socket-event';
import { SocketService } from '../../../../core/socket/socket-service';
import { CommandEvent, DataEvent, IntersectionEvent } from 'web-shared';
import { LuaSetting } from '../../../../shared/model/lua-setting';

// socket.listen\('\[Data-(.*)\]'\);
// socket.listen(DataEvent.eventOf('$1'));this.socket.join(DataEvent.roomOf('$1'));

@Injectable({
  providedIn: 'root',
})
export class IntersectionService {
  private intersectionActions$: Observable<string>;
  private laneActions$: Observable<string>;
  private switchingActions$: Observable<string>;
  private trafficLightActions$: Observable<string>;
  private luaModuleSettingsActions$: Observable<string>;

  constructor(private socket: SocketService) {}

  getIntersectionActions(): Observable<string> {
    if (!this.intersectionActions$) {
      this.intersectionActions$ = this.socket.listen(DataEvent.eventOf('intersections'));
      this.socket.join(DataEvent.roomOf('intersections'));
    }
    return this.intersectionActions$;
  }

  getLaneActions(): Observable<string> {
    if (!this.laneActions$) {
      this.laneActions$ = this.socket.listen(DataEvent.eventOf('intersection-lanes'));
      this.socket.join(DataEvent.roomOf('intersection-lanes'));
    }
    return this.laneActions$;
  }

  getSwitchingActions(): Observable<string> {
    if (!this.switchingActions$) {
      this.switchingActions$ = this.socket.listen(DataEvent.eventOf('intersection-switchings'));
      this.socket.join(DataEvent.roomOf('intersection-switchings'));
    }
    return this.switchingActions$;
  }

  getTrafficLightActions(): Observable<string> {
    if (!this.trafficLightActions$) {
      this.trafficLightActions$ = this.socket.listen(DataEvent.eventOf('intersection-traffic-lights'));
      this.socket.join(DataEvent.roomOf('intersection-traffic-lights'));
    }
    return this.trafficLightActions$;
  }

  getLuaSettingsReceivedActions(): Observable<string> {
    if (!this.luaModuleSettingsActions$) {
      this.luaModuleSettingsActions$ = this.socket.listen(DataEvent.eventOf('intersection-module-settings'));
      this.socket.join(DataEvent.roomOf('intersection-module-settings'));
    }
    return this.luaModuleSettingsActions$;
  }

  changeModuleSettings(setting: LuaSetting<any>, value: any) {
    this.socket.emit(CommandEvent.ChangeSetting, { name: setting.name, func: setting.eepFunction, newValue: value });
  }

  changeStaticCam(staticCam: string) {
    this.socket.emit(CommandEvent.ChangeStaticCam, { staticCam });
  }

  switchAutomatically(intersectionName: string) {
    this.socket.emit(IntersectionEvent.SwitchAutomatically, { intersectionName });
  }

  switchManually(intersectionName: string, switchingName: string) {
    this.socket.emit(IntersectionEvent.SwitchManually, {
      intersectionName,
      switchingName,
    });
  }
}
