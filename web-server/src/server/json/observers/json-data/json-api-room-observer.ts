import express = require('express');
import { Server, Socket } from 'socket.io';
import { CacheService } from '../../../eep/cache-service';
import { DataEvent, ServerStatusEvent } from 'web-shared';
import JsonDataStore, { State } from '../../json-data-reducer';
import StateObserver from '../state-observer';
import JsonApiReducer, { ServerData } from './json-api-reducer';

export default class JsonDataObserver implements StateObserver {
  private debug = true;
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
      const room = DataEvent.roomOf(roomName);
      if (room === room) {
        const event = DataEvent.eventOf(roomName);
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
  onStateChange = (store: Readonly<JsonDataStore>) => {
    const currentState: State = store.currentState();
    const oldData: ServerData = this.reducer.getLastAnnouncedData();
    const data: ServerData = JsonApiReducer.calculateData(currentState);
    this.cacheService.writeCache(currentState as undefined);
    this.reducer.setLastAnnouncedData(data);

    this.announceEepData(store, oldData, data, currentState.eventCounter);
  };

  private announceEepData(
    store: Readonly<JsonDataStore>,
    oldData: ServerData,
    data: ServerData,
    eventCounter: number
  ): void {
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
    this.io.to(DataEvent.roomOf(key)).emit(DataEvent.eventOf(key), json);
  }

  private onRoomChanged(key: string, json: string): void {
    this.io.to(DataEvent.roomOf(key)).emit(DataEvent.eventOf(key), json);
  }

  private onRoomRemoved(key: string): void {
    this.io.to(ServerStatusEvent.Room).emit(ServerStatusEvent.UrlsChanged, this.reducer.getUrlJson());
    this.io.to(DataEvent.roomOf(key)).emit(DataEvent.eventOf(key), '{}');
  }

  private registerApiUrls(key: string) {
    console.log('Register: /api/v1/' + key);
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
}
