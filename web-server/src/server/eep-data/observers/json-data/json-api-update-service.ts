import express from 'express';
import { Server, Socket } from 'socket.io';
import { CacheService } from '../../../eep-service/cache-service';
import { ServerStatusEvent } from 'web-shared';
import EepDataStore, { State } from '../../eep-data-reducer';
import JsonApiReducer, { ServerData } from './json-api-reducer';

import { ApiDataRoom } from 'web-shared/build/rooms';

export default class JsonApiUpdateService {
  private debug = false;
  private reducer = new JsonApiReducer();

  constructor(
    private app: express.Express,
    private router: express.Router,
    private io: Server,
    private cacheService: CacheService
  ) {}

  onJoinRoom = (socket: Socket, room: string) => {
    // Send data on join
    const roomNames = this.reducer.getAllRoomNames();
    for (const roomName of roomNames) {
      // Send datatype events to datatype rooms
      const room = ApiDataRoom.roomId(roomName);
      if (room === room) {
        const event = ApiDataRoom.eventId(roomName);
        if (this.debug) console.log('EMIT ' + event + ' to ' + socket.id);
        socket.emit(event, this.reducer.getRoomJsonString(roomName));
      }
    }

    // Send JsonKeys to all JsonKey rooms
    if (room === ServerStatusEvent.Room) {
      if (this.debug) console.log('EMIT ' + ServerStatusEvent.UrlsChanged + ' to ' + socket.id);
      socket.emit(ServerStatusEvent.UrlsChanged, this.reducer.getUrlJson());
    }
  };

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  onLeaveRoom = (socket: Socket, room: string) => {
    // Nothing to do here
  };

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  onSocketClose = (socket: Socket): void => {
    // Nothing to do here yet
  };

  onStateChange = (store: Readonly<EepDataStore>) => {
    const currentState: State = store.currentState();
    const oldData: ServerData = this.reducer.getLastAnnouncedData();
    const data: ServerData = JsonApiReducer.calculateData(currentState);
    if (!store.hasInitialState()) {
      this.cacheService.writeCache(currentState as undefined);
    }
    this.reducer.setLastAnnouncedData(data);
    this.registerStatsTimeout(data);

    this.announceEepData(oldData, data, currentState.eventCounter);
  };

  private announceEepData(oldData: ServerData, data: ServerData, eventCounter: number): void {
    // Get those new room names from the Json Content
    const oldRooms = Object.keys(oldData.roomToJson);
    const newRooms = Object.keys(data.roomToJson);

    // Calculate room changes
    const addedRooms = newRooms.filter((el) => !oldRooms.includes(el));
    const removedRooms = oldRooms.filter((el) => !newRooms.includes(el));
    const roomsToCheck = newRooms.filter((el) => oldRooms.includes(el));
    const modifiedRooms = JsonApiReducer.calcChangedRooms(roomsToCheck, oldData, data);

    // Inform the data listeners
    for (const roomName of addedRooms) {
      this.onRoomAdded(roomName, this.reducer.getRoomJsonString(roomName));
    }
    for (const roomName of modifiedRooms) {
      this.onRoomChanged(roomName, this.reducer.getRoomJsonString(roomName));
    }
    for (const roomName of removedRooms) {
      this.onRoomRemoved(roomName);
    }

    // Inform about URL listeners
    if (addedRooms.length > 0 || removedRooms.length > 0) {
      this.io.to(ServerStatusEvent.Room).emit(ServerStatusEvent.UrlsChanged, this.reducer.getUrlJson());
    }

    // console.log('EventCounter: ', currentState.eventCounter);
    this.io.to(ServerStatusEvent.Room).emit(ServerStatusEvent.CounterUpdated, eventCounter);
  }

  private onRoomAdded(key: string, json: string): void {
    this.registerApiUrls(key);
    this.io.to(ApiDataRoom.roomId(key)).emit(ApiDataRoom.eventId(key), json);
  }

  private onRoomChanged(key: string, json: string): void {
    this.io.to(ApiDataRoom.roomId(key)).emit(ApiDataRoom.eventId(key), json);
  }

  private onRoomRemoved(key: string): void {
    this.io.to(ServerStatusEvent.Room).emit(ServerStatusEvent.UrlsChanged, this.reducer.getUrlJson());
    this.io.to(ApiDataRoom.roomId(key)).emit(ApiDataRoom.eventId(key), '{}');
  }

  private registerApiUrls(key: string) {
    if (this.debug) console.log('Register: /api/v1/' + key);
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    this.router.get('/' + key, (req: any, res: any) => {
      res.json(this.getCurrentApiEntry(key));
    });
  }

  private getCurrentApiEntry(roomName: string) {
    if (this.reducer.roomAvailable(roomName)) {
      return this.reducer.getRoomJson(roomName);
    } else {
      return '';
    }
  }

  private lastTimeOut: NodeJS.Timeout;

  private registerStatsTimeout(data: ServerData) {
    if (this.lastTimeOut) {
      clearTimeout(this.lastTimeOut);
    }
    this.lastTimeOut = setTimeout(() => {
      const roomName = 'api-stats';
      const currentStats = JSON.parse(data.roomToJson[roomName]);
      const newStats = { ...currentStats, eepDataUpToDate: false };
      const newStatsJsonString = JSON.stringify(newStats);
      data.roomToJson[roomName] = newStatsJsonString;
      this.io.to(ApiDataRoom.roomId(roomName)).emit(ApiDataRoom.eventId(roomName), newStatsJsonString);
    }, 1000);
  }
}
