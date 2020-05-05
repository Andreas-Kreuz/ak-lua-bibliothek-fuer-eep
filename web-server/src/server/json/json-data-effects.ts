import express = require('express');
import { performance } from 'perf_hooks';
import { Server, Socket } from 'socket.io';

import { DataEvent, RoomEvent, ServerStatusEvent } from 'web-shared';
import SocketService from '../clientio/socket-service';
import JsonDataStore from './json-data-reducer';

export default class JsonDataEffects {
  [x: string]: any;
  private store = new JsonDataStore(this);

  constructor(
    private app: express.Express,
    private router: express.Router,
    private io: Server,
    private socketService: SocketService
  ) {
    this.socketService.addOnSocketConnectedCallback((socket: Socket) => this.socketConnected(socket));
  }

  private socketConnected(socket: Socket) {
    socket.on(RoomEvent.JoinRoom, (rooms: { room: string }) => {
      console.log('EMIT ' + ServerStatusEvent.Room + ' to interested parties');

      // Send data on join
      const keys = Object.keys(this.store.getJsonData());
      for (const key of keys) {
        // Send datatype events to datatype rooms
        const room = DataEvent.roomOf(key);
        if (room === rooms.room) {
          const event = DataEvent.eventOf(key);
          console.log('EMIT ' + event + ' to ' + socket.id);
          socket.emit(event, JSON.stringify(this.store.getJsonData()[key]));
        }
      }

      // Send JsonKeys to all JsonKey rooms
      if (rooms.room === ServerStatusEvent.Room) {
        socket.join(ServerStatusEvent.Room);
        console.log('EMIT ' + ServerStatusEvent.UrlsChanged + ' to ' + socket.id);
        socket.emit(ServerStatusEvent.UrlsChanged, JSON.stringify(this.store.getUrls()));
      }
    });
  }

  jsonDataUpdated(jsonString: string): void {
    // Parse the data
    const newJsonContent: { [key: string]: any[] } = JSON.parse(jsonString);

    // Get those new keys from the Json Content
    const currentKeys = Object.keys(this.store.getJsonData());
    const newJsonKeys = Object.keys(newJsonContent);
    const keysToAdd = newJsonKeys.filter((el) => !currentKeys.includes(el));
    const keysToCheck = newJsonKeys.filter((el) => currentKeys.includes(el));
    const keysToRemove = currentKeys.filter((el) => !newJsonKeys.includes(el));

    // Calculate the changes
    const changedKeys = this.store.calcChangedKeys(keysToCheck, newJsonContent);

    // Store data
    this.store.setJsonData(newJsonContent);
    this.store.addUrls(keysToAdd);
    this.store.removeUrls(keysToRemove);

    // Inform the data listeners
    for (const key of keysToAdd) {
      this.onDataAdded(key, JSON.stringify(this.store.getJsonData()[key]));
    }
    for (const key of changedKeys) {
      this.onDataChanged(key, JSON.stringify(this.store.getJsonData()[key]));
    }
    for (const key of keysToRemove) {
      this.onDataRemoved(key);
    }

    // Inform about URL listeners
    if (keysToAdd.length > 0 || keysToRemove.length > 0) {
      this.io.to(ServerStatusEvent.Room).emit(ServerStatusEvent.UrlsChanged, JSON.stringify(this.store.getUrls()));
    }
  }

  public onDataAdded(key: string, json: string): void {
    this.store.addDataRoom(DataEvent.roomOf(key));
    this.registerApiUrls(key);
    this.io.to(DataEvent.roomOf(key)).emit(DataEvent.eventOf(key), json);
  }

  public onDataChanged(key: string, json: string): void {
    this.io.to(DataEvent.roomOf(key)).emit(DataEvent.eventOf(key), json);
  }

  public onDataRemoved(key: string): void {
    this.store.removeDataRoom(DataEvent.roomOf(key));
    this.io.to(ServerStatusEvent.Room).emit(ServerStatusEvent.UrlsChanged, JSON.stringify(this.store.getUrls()));
    this.io.to(DataEvent.roomOf(key)).emit(DataEvent.eventOf(key));
  }

  private sendToDataRoom() {}

  private registerApiUrls(key: string) {
    console.log('Register: /api/v1/' + key);
    this.router.get('/' + key, (req: any, res: any) => {
      res.json(this.getCurrentApiEntry(key));
    });
    this.app.use('/api/v1', this.router);
  }

  private getCurrentApiEntry(key: string) {
    if (this.store.hasJsonKey(key)) {
      return this.store.getJsonData()[key];
    } else {
      return '';
    }
  }
}
