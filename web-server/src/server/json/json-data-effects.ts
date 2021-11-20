import express = require('express');
import { Server, Socket } from 'socket.io';

import { DataEvent, RoomEvent, ServerStatusEvent } from 'web-shared';
import SocketService from '../clientio/socket-service';
import JsonDataStore, { ServerData, State } from './json-data-reducer';
import EepEvent from './eep-event';
import { CacheService } from '../eep/cache-service';

export default class JsonDataEffects {
  private debug = false;
  private store = new JsonDataStore(this);
  private refreshSettings = { pending: true, inProgress: false };

  constructor(
    private app: express.Express,
    private router: express.Router,
    private io: Server,
    private socketService: SocketService,
    private cacheService: CacheService
  ) {
    this.store.init(this.cacheService.readCache());
    console.log('STORE INITIALIZED FROM ' + (this.store.currentState().eventCounter + 1) + ' events');

    this.socketService.addOnSocketConnectedCallback((socket: Socket) => this.socketConnected(socket));
    setInterval(() => this.refreshStateIfRequired(), 50);
  }

  private socketConnected(socket: Socket) {
    socket.on(RoomEvent.JoinRoom, (rooms: { room: string }) => {
      if (this.debug) console.log('EMIT ' + ServerStatusEvent.Room + ' to interested parties');

      // Send data on join
      const roomNames = this.store.getAllRoomNames();
      for (const roomName of roomNames) {
        // Send datatype events to datatype rooms
        const room = DataEvent.roomOf(roomName);
        if (room === rooms.room) {
          const event = DataEvent.eventOf(roomName);
          if (this.debug) console.log('EMIT ' + event + ' to ' + socket.id);
          socket.emit(event, this.store.getRoomJsonString(roomName));
        }
      }

      // Send JsonKeys to all JsonKey rooms
      if (rooms.room === ServerStatusEvent.Room) {
        socket.join(ServerStatusEvent.Room);
        if (this.debug) console.log('EMIT ' + ServerStatusEvent.UrlsChanged + ' to ' + socket.id);
        socket.emit(ServerStatusEvent.UrlsChanged, this.store.getUrlJson());
        socket.emit(ServerStatusEvent.CounterUpdated, JSON.stringify(this.store.getEventCounter()));
      }
    });
  }

  refreshStateIfRequired() {
    if (this.refreshSettings.pending === true && this.refreshSettings.inProgress === false) {
      this.refreshSettings.inProgress = true;
      this.announceState();
      this.refreshSettings.inProgress = false;
      this.refreshSettings.pending = false;
    }
  }

  onNewEventLine(jsonString: string) {
    try {
      const event: EepEvent = JSON.parse(jsonString);
      const expectedEventNr = this.store.currentState().eventCounter + 1;
      const receivedEventNr = event.eventCounter;

      // Fire this event only if it is expected or a complete reset
      if (receivedEventNr == 1 || expectedEventNr == receivedEventNr || event.type === 'CompleteReset') {
        this.store.onNewEvent(event);
        this.refreshSettings.pending = true;
      } else if (receivedEventNr > expectedEventNr) {
        console.error(
          'STATE OUT OF SYNC: Expected next event: ' + expectedEventNr + ' / Received Event: ' + receivedEventNr
        );
      } else {
        console.log('STATE expected: ' + expectedEventNr + ' / State received: ' + receivedEventNr);
      }
    } catch (e) {
      console.error(jsonString.length, jsonString.substr(0, 20));
      console.error(e);
    }
  }

  announceState(): void {
    // Parse the data
    const currentState: State = this.store.currentState();
    const oldData: ServerData = this.store.getLastAnnouncedData();
    const data: ServerData = JsonDataStore.calculateData(currentState);
    this.cacheService.writeCache(currentState as undefined);
    this.store.setLastAnnouncedData(data);

    // Get those new room names from the Json Content
    const oldRooms = Object.keys(oldData.roomToJson);
    const newRooms = Object.keys(data.roomToJson);

    // Calculate room changes
    const addedRooms = newRooms.filter((el) => !oldRooms.includes(el));
    const removedRooms = oldRooms.filter((el) => !newRooms.includes(el));
    const roomsToCheck = newRooms.filter((el) => oldRooms.includes(el));
    const modifiedRooms = JsonDataStore.calcChangedRooms(roomsToCheck, oldData, data);

    // Inform the data listeners
    for (const roomName of addedRooms) {
      this.onRoomAdded(roomName, this.store.getRoomJsonString(roomName));
    }
    for (const roomName of modifiedRooms) {
      this.onRoomChanged(roomName, this.store.getRoomJsonString(roomName));
    }
    for (const roomName of removedRooms) {
      this.onRoomRemoved(roomName);
    }

    // Inform about URL listeners
    if (addedRooms.length > 0 || removedRooms.length > 0) {
      this.io.to(ServerStatusEvent.Room).emit(ServerStatusEvent.UrlsChanged, this.store.getUrlJson());
    }

    // console.log('EventCounter: ', currentState.eventCounter);
    this.io.to(ServerStatusEvent.Room).emit(ServerStatusEvent.CounterUpdated, currentState.eventCounter);
  }

  private onRoomAdded(key: string, json: string): void {
    this.registerApiUrls(key);
    this.io.to(DataEvent.roomOf(key)).emit(DataEvent.eventOf(key), json);
  }

  private onRoomChanged(key: string, json: string): void {
    this.io.to(DataEvent.roomOf(key)).emit(DataEvent.eventOf(key), json);
  }

  private onRoomRemoved(key: string): void {
    this.io.to(ServerStatusEvent.Room).emit(ServerStatusEvent.UrlsChanged, this.store.getUrlJson());
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
    if (this.store.roomAvailable(roomName)) {
      return this.store.getRoomJson(roomName);
    } else {
      return '';
    }
  }
}
