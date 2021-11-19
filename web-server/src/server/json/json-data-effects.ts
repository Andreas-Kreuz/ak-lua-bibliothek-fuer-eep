import express = require('express');
import { Server, Socket } from 'socket.io';

import { DataEvent, RoomEvent, ServerStatusEvent } from 'web-shared';
import SocketService from '../clientio/socket-service';
import JsonDataStore, { State } from './json-data-reducer';
import EepEvent from './eep-event';

export default class JsonDataEffects {
  [x: string]: unknown;
  private store = new JsonDataStore(this);
  private refreshSettings = { pending: false, inProgress: false };

  constructor(
    private app: express.Express,
    private router: express.Router,
    private io: Server,
    private socketService: SocketService
  ) {
    this.socketService.addOnSocketConnectedCallback((socket: Socket) => this.socketConnected(socket));
    setInterval(() => this.refreshStateIfRequired(), 200);
  }

  private socketConnected(socket: Socket) {
    socket.on(RoomEvent.JoinRoom, (rooms: { room: string }) => {
      if (this.debug) console.log('EMIT ' + ServerStatusEvent.Room + ' to interested parties');

      // Send data on join
      const keys = Object.keys(this.store.getJsonData());
      for (const key of keys) {
        // Send datatype events to datatype rooms
        const room = DataEvent.roomOf(key);
        if (room === rooms.room) {
          const event = DataEvent.eventOf(key);
          if (this.debug) console.log('EMIT ' + event + ' to ' + socket.id);
          socket.emit(event, JSON.stringify(this.store.getJsonData()[key]));
        }
      }

      // Send JsonKeys to all JsonKey rooms
      if (rooms.room === ServerStatusEvent.Room) {
        socket.join(ServerStatusEvent.Room);
        if (this.debug) console.log('EMIT ' + ServerStatusEvent.UrlsChanged + ' to ' + socket.id);
        socket.emit(ServerStatusEvent.UrlsChanged, JSON.stringify(this.store.getUrls()));
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
    const event: EepEvent = JSON.parse(jsonString);
    this.store.onNewEvent(event);
    this.refreshSettings.pending = true;
  }

  announceState(): void {
    // Parse the data
    const currentState: State = this.store.currentState();
    const currentRoomData: { [key: string]: unknown } = { ...currentState.rooms };

    // Get those new room names from the Json Content
    const oldRooms = Object.keys(this.store.getJsonData());
    const newRooms = Object.keys(currentRoomData);

    // Calculate room changes
    const addedRooms = newRooms.filter((el) => !oldRooms.includes(el));
    const removedRooms = oldRooms.filter((el) => !newRooms.includes(el));
    const roomsToCheck = newRooms.filter((el) => oldRooms.includes(el));
    const modifiedRooms = this.store.calcChangedRooms(roomsToCheck, currentRoomData);
    // console.log('Changed Rooms: ', modifiedRooms);

    // Store data
    this.store.setLastAnnouncedState(currentRoomData);
    this.store.addUrls(addedRooms);
    this.store.removeUrls(removedRooms);

    // Inform the data listeners
    for (const room of addedRooms) {
      this.onRoomAdded(room, JSON.stringify(this.store.getJsonData()[room]));
    }
    for (const room of modifiedRooms) {
      this.onRoomChanged(room, JSON.stringify(this.store.getJsonData()[room]));
    }
    for (const room of removedRooms) {
      this.onRoomRemoved(room);
    }

    // Inform about URL listeners
    if (addedRooms.length > 0 || removedRooms.length > 0) {
      this.io.to(ServerStatusEvent.Room).emit(ServerStatusEvent.UrlsChanged, JSON.stringify(this.store.getUrls()));
    }

    // console.log('EventCounter: ', currentState.eventCounter);
    this.io.to(ServerStatusEvent.Room).emit(ServerStatusEvent.CounterUpdated, currentState.eventCounter);
  }

  public onRoomAdded(key: string, json: string): void {
    this.registerApiUrls(key);
    this.io.to(DataEvent.roomOf(key)).emit(DataEvent.eventOf(key), json);
  }

  public onRoomChanged(key: string, json: string): void {
    this.io.to(DataEvent.roomOf(key)).emit(DataEvent.eventOf(key), json);
  }

  public onRoomRemoved(key: string): void {
    this.io.to(ServerStatusEvent.Room).emit(ServerStatusEvent.UrlsChanged, JSON.stringify(this.store.getUrls()));
    this.io.to(DataEvent.roomOf(key)).emit(DataEvent.eventOf(key), '{}');
  }

  private registerApiUrls(key: string) {
    console.log('Register: /api/v1/' + key);
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    this.router.get('/' + key, (req: any, res: any) => {
      res.json(this.getCurrentApiEntry(key));
    });
  }

  private getCurrentApiEntry(key: string) {
    if (this.store.hasJsonKey(key)) {
      return this.store.getJsonData()[key];
    } else {
      return '';
    }
  }
}
