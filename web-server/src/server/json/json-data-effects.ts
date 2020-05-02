import express = require('express');
import { Server, Socket } from 'socket.io';

import { Room } from 'web-shared';
import SocketService from '../clientio/socket-service';
import JsonDataStore from './json-data-reducer';

export default class JsonDataEffects {
  [x: string]: any;
  private store = new JsonDataStore(this);

  constructor(private app: express.Express, private io: Server, private socketService: SocketService) {
    this.registerAvailableApiUrl();
    this.socketService.addOnRoomsJoinedCallback((socket: Socket, joinedRoom: string) =>
      this.onRoomsJoined(socket, joinedRoom)
    );
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
      this.onDataAdded(key, this.store.getJsonData()[key]);
    }
    for (const key of changedKeys) {
      this.onDataChanged(key, JSON.stringify(this.store.getJsonData()[key]));
    }
    for (const key of keysToRemove) {
      this.onDataRemoved(key);
    }

    // Inform about URL listeners
    if (keysToAdd.length > 0 || keysToRemove.length > 0) {
      this.io.to(Room.JsonUrls).emit(Room.JsonUrls, JSON.stringify(this.store.getUrls()));
    }
  }

  private onRoomsJoined = (socket: Socket, joinedRoom: string): void => {
    console.log('EMIT ' + Room.JsonUrls + ' to interested parties');

    // Send data on join
    const keys = Object.keys(this.store.getJsonData());
    for (const key of keys) {
      // Send datatype events to datatype rooms
      const room = Room.ofDataType(key);
      if (room === joinedRoom) {
        console.log('EMIT ' + room + ' to ' + socket.id);
        socket.emit(room, JSON.stringify(this.store.getJsonData()[key]));
      }
    }

    // Send JsonKeys to all JsonKey rooms
    if (joinedRoom === Room.JsonUrls) {
      socket.join(Room.JsonUrls);
      console.log('EMIT ' + Room.JsonUrls + ' to ' + socket.id);
      socket.emit(Room.JsonUrls, JSON.stringify(this.store.getUrls()));
    }

    // Send URLs to all URLs rooms
    if (joinedRoom === Room.AvailableDataTypes) {
      socket.join(Room.AvailableDataTypes);
      console.log('EMIT ' + Room.AvailableDataTypes + ' to ' + socket.id);
      socket.emit(Room.AvailableDataTypes, JSON.stringify(this.store.getDataRooms()));
    }
    // tslint:disable-next-line: semicolon
  };

  public onDataAdded(key: string, json: string): void {
    this.store.addDataRoom(Room.ofDataType(key));
    this.registerApiUrls(key);
    this.io.to(Room.ofDataType(key)).emit(Room.ofDataType(key), json);
  }

  public onDataChanged(key: string, json: string): void {
    this.io.to(Room.ofDataType(key)).emit(Room.ofDataType(key), json);
  }

  public onDataRemoved(key: string): void {
    this.store.removeDataRoom(Room.ofDataType(key));
    this.io.to(Room.JsonUrls).emit(Room.JsonUrls, JSON.stringify(this.store.getUrls()));
    this.io.to(Room.ofDataType(key)).emit(Room.ofDataType(key), '');
  }

  private registerAvailableApiUrl() {
    console.log('Register: /api/v1/api-entries');
    const router = express.Router();
    router.get('/api-entries', (req: any, res: any) => {
      res.json(this.store.getDataRooms());
    });
    this.app.use('/api/v1', router);
  }

  private registerApiUrls(key: string) {
    console.log('Register: /api/v1/' + key);
    const router = express.Router();
    router.get('/' + key, (req: any, res: any) => {
      res.json(this.getCurrentApiEntry(key));
    });
    this.app.use('/api/v1', router);
  }

  private getCurrentApiEntry(key: string) {
    if (this.store.hasJsonKey(key)) {
      return this.store.getJsonData()[key];
    } else {
      return '';
    }
  }
}
