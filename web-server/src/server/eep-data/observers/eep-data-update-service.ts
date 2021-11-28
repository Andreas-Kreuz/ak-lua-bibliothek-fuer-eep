import { Server, Socket } from 'socket.io';
import EepDataStore from '../eep-data-reducer';
import { DynamicRoom } from 'web-shared/build/rooms';
import FeatureUpdateService, { FeatureUpdater, SocketDataProvider } from './socket-data-provider';

export default class EepDataUpdateService {
  private debug = false;
  private dataUpdaters: FeatureUpdater[] = [];
  private roomMap: Map<
    DynamicRoom,
    {
      id: string;
      jsonCreator: (roomName: string) => string;
      lastDataCache: Map<string, string>;
      currentData: Map<string, string>;
      sockets: Map<Socket, string>;
    }
  > = new Map();

  constructor(private io: Server) {}

  registerFeatureService(observer: FeatureUpdateService) {
    observer.getDataUpdaters().forEach((element: FeatureUpdater) => {
      this.dataUpdaters.push(element);
    });

    observer.getSocketSettings().forEach((provider: SocketDataProvider) => {
      this.roomMap.set(provider.roomType, {
        id: provider.id,
        jsonCreator: provider.jsonCreator,
        lastDataCache: new Map(),
        currentData: new Map(),
        sockets: new Map(),
      });
    });
  }

  // addDataUpdater = (name: string, updater: { updateFromState: (state: Readonly<EepDataStore>) => void }) =>

  // addDynamicRoom = (
  //   dynamicRoomType: DynamicRoom,
  //   roomSettings: {
  //     id: string;
  //     jsonCreator: (roomName: string) => string;
  //   }
  // ) =>
  //   this.roomMap.set(dynamicRoomType, {
  //     id: roomSettings.id,
  //     jsonCreator: roomSettings.jsonCreator,
  //     lastDataCache: new Map(),
  //     currentData: new Map(),
  //     sockets: new Map(),
  //   });

  onStateChange(store: Readonly<EepDataStore>): void {
    this.dataUpdaters.forEach((updater) => {
      updater.updateFromState(store.currentState());
    });

    this.roomMap.forEach((dynRoomSetting, dynRoom) => {
      const lastDataCache = dynRoomSetting.lastDataCache;
      const roomSockets = dynRoomSetting.sockets;
      const jsonCreator = dynRoomSetting.jsonCreator;
      const currentData: Map<string, string> = new Map();
      const modifiedRooms: Map<string, boolean> = new Map();

      if (this.debug) console.log('ID', dynRoomSetting.id, roomSockets.size);

      // Which rooms need an update
      const roomNames: Map<string, boolean> = new Map();
      roomSockets.forEach((nameOfRoom) => roomNames.set(nameOfRoom, true));

      // Calculate the new data
      roomNames.forEach((_, nameOfRoom) => {
        const oldJson = lastDataCache.get(nameOfRoom);
        const newJson = jsonCreator(nameOfRoom);
        currentData.set(nameOfRoom, newJson);
        modifiedRooms.set(nameOfRoom, oldJson !== newJson);
      });

      dynRoomSetting.sockets.forEach((nameOfRoom) => {
        if (modifiedRooms.get(nameOfRoom) === true) {
          const eventName = dynRoom.eventId(dynRoom.idOfRoom(nameOfRoom));
          this.io.to(nameOfRoom).emit(eventName, currentData.get(nameOfRoom));
          if (this.debug) console.log('Sending Data to ', nameOfRoom, currentData.get(nameOfRoom));
        } else {
          if (this.debug) console.log('Skipping data event to ', nameOfRoom);
        }
      });

      // Store the room data for the next update
      dynRoomSetting.lastDataCache = currentData;
    });
  }

  onJoinRoom = (socket: Socket, nameOfRoom: string): void => {
    this.roomMap.forEach((dynRoomSetting, room) => {
      if (room.matchesRoom(nameOfRoom)) {
        const eventName = room.eventId(room.idOfRoom(nameOfRoom));
        dynRoomSetting.sockets.set(socket, nameOfRoom);
        socket.emit(eventName, dynRoomSetting.jsonCreator(nameOfRoom));
        if (this.debug)
          console.log(dynRoomSetting.id, ': sending event', eventName, ' to ', nameOfRoom, ' on socket ', socket);
      }
    });
  };

  onLeaveRoom = (socket: Socket, nameOfRoom: string): void => {
    this.roomMap.forEach((dynRoomSetting, room) => {
      if (room.matchesRoom(nameOfRoom)) {
        dynRoomSetting.sockets.delete(socket);
        if (this.debug) console.log(dynRoomSetting.id, ': disconnect ', nameOfRoom, ' from socket ', socket);
      }
    });
  };

  onSocketClose = (socket: Socket): void => {
    this.roomMap.forEach((dynRoomSetting) => {
      dynRoomSetting.sockets.delete(socket);
      if (this.debug) console.log(dynRoomSetting.id, ': disconnect socket ', socket);
    });
  };
}
