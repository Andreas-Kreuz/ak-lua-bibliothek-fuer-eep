import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { SocketService } from '../../../../core/socket/socket-service';
import { CommandEvent, IntersectionEvent } from 'web-shared';
import { ApiDataRoom } from 'web-shared/build/rooms';
import { LuaSetting } from '../../../../shared/model/lua-setting';
import { EepCommandService } from '../../../../common/eep-communication/eep-command.service';

@Injectable({
  providedIn: 'root',
})
export class IntersectionService {
  private intersectionActions$: Observable<string>;
  private laneActions$: Observable<string>;
  private switchingActions$: Observable<string>;
  private trafficLightActions$: Observable<string>;
  private luaModuleSettingsActions$: Observable<string>;

  constructor(private socket: SocketService, private eepCommandService: EepCommandService) {}

  getIntersectionActions(): Observable<string> {
    if (!this.intersectionActions$) {
      this.intersectionActions$ = this.socket.listenToData(ApiDataRoom, 'intersections');
    }
    return this.intersectionActions$;
  }

  getLaneActions(): Observable<string> {
    if (!this.laneActions$) {
      this.laneActions$ = this.socket.listenToData(ApiDataRoom, 'intersection-lanes');
    }
    return this.laneActions$;
  }

  getSwitchingActions(): Observable<string> {
    if (!this.switchingActions$) {
      this.switchingActions$ = this.socket.listenToData(ApiDataRoom, 'intersection-switchings');
    }
    return this.switchingActions$;
  }

  getTrafficLightActions(): Observable<string> {
    if (!this.trafficLightActions$) {
      this.trafficLightActions$ = this.socket.listenToData(ApiDataRoom, 'intersection-traffic-lights');
    }
    return this.trafficLightActions$;
  }

  getLuaSettingsReceivedActions(): Observable<string> {
    if (!this.luaModuleSettingsActions$) {
      this.luaModuleSettingsActions$ = this.socket.listenToData(ApiDataRoom, 'intersection-module-settings');
    }
    return this.luaModuleSettingsActions$;
  }

  changeModuleSettings(setting: LuaSetting<any>, value: any) {
    this.socket.emit(CommandEvent.ChangeSetting, { name: setting.name, func: setting.eepFunction, newValue: value });
  }

  changeStaticCam(staticCam: string) {
    this.eepCommandService.setCamera(staticCam);
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
