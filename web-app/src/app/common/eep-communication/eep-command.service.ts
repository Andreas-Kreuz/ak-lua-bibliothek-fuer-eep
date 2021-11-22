import { Injectable } from '@angular/core';
import { CommandEvent } from 'web-shared';
import { SocketService } from '../../core/socket/socket-service';

@Injectable({
  providedIn: 'root',
})
export class EepCommandService {
  constructor(private socket: SocketService) {}

  setCamera(staticCamName: string) {
    this.socket.emit(CommandEvent.ChangeCamToStatic, { staticCam: staticCamName });
  }

  setCamToTrain(trainName: string, id?: number) {
    this.socket.emit(CommandEvent.ChangeCamToTrain, { trainName, id });
  }

  setCamToRollingStock(rollingStock: string, posX: number, posY: number, posZ: number, redH: number, redV: number) {
    this.socket.emit(CommandEvent.ChangeCamToRollingStock, { rollingStock, posX, posY, posZ, redH, redV });
  }
}
