import express = require('express');
import { Server, Socket } from 'socket.io';

import { Room, SocketEvent } from 'web-shared';
import SocketManager from './socket-manager';

export default class JsonDataManager {
  private currentJsonContent: { [key: string]: any[] } = {};
  private knownUrls: string[] = [];

  constructor(private app: express.Express, private io: Server, private socketMgr: SocketManager) {
    this.socketMgr.addOnRoomsJoinedCallback((socket: Socket, joinedRooms: string[]) =>
      this.onRoomsJoined(socket, joinedRooms)
    );
  }

  /**
   * This will fill the API and send Socket Events to all listeners
   * @param jsonString JsonString from EEP
   */
  public jsonDataUpdated(jsonString: string): void {
    // Parse the data
    const newJsonContent: { [key: string]: any[] } = JSON.parse(jsonString);

    // Get those new keys from the Json Content
    const currentKeys = Object.keys(this.currentJsonContent);
    const newJsonKeys = Object.keys(newJsonContent);
    const keysToAdd = newJsonKeys.filter((el) => !currentKeys.includes(el));
    const keysToCheck = newJsonKeys.filter((el) => currentKeys.includes(el));
    const keysToRemove = currentKeys.filter((el) => !newJsonKeys.includes(el));

    this.removeDataForKeys(keysToRemove);
    this.checkDataForKeys(keysToCheck, newJsonContent);
    this.addDataForKeys(keysToAdd, newJsonContent);

    // Store data
    this.currentJsonContent = newJsonContent;
  }

  private addDataForKeys(keysToAdd: string[], newJsonContent: { [key: string]: any[] }) {
    for (const key of keysToAdd) {
      this.currentJsonContent[key] = newJsonContent[key];
      this.onDataAdded(key, JSON.stringify(newJsonContent[key]));
    }
  }

  private checkDataForKeys(keysToCheck: string[], newJsonContent: { [key: string]: any[] }) {
    for (const key of keysToCheck) {
      const currentData = JSON.stringify(this.currentJsonContent[key]);
      const newData = JSON.stringify(this.currentJsonContent[key]);
      if (currentData !== newData) {
        this.currentJsonContent[key] = newJsonContent[key];
        this.onDataChanged(key, JSON.stringify(newJsonContent[key]));
      }
    }
  }

  private removeDataForKeys(keysToRemove: string[]) {
    for (const key of keysToRemove) {
      delete this.currentJsonContent[key];
      this.onDataRemoved(key);
    }
  }

  public getCurrentApiEntry(key: string) {
    if (this.currentJsonContent.hasOwnProperty(key)) {
      return this.currentJsonContent[key];
    } else {
      return null;
    }
  }

  private onRoomsJoined(socket: Socket, joinedRooms: string[]): void {
    // Send data on join
    const keys = Object.keys(this.currentJsonContent).filter((key) =>
      Object.keys(joinedRooms).includes(Room.ofDataType(key))
    );
    for (const key of keys) {
      const room = Room.ofDataType(key);
      console.log('EMIT ' + room + ' to ' + socket.id);
      socket.emit(room, JSON.stringify(this.currentJsonContent[key]));
    }

    if (joinedRooms.indexOf(Room.URLS) > -1) {
      socket.join(Room.URLS);
      console.log('EMIT ' + Room.URLS + ' to ' + socket.id);
      socket.emit(Room.URLS, JSON.stringify(this.knownUrls));
    }
  }

  public onDataAdded(key: string, json: string): void {
    this.urlAdded(key);
    this.registerApiUrls(key);
    this.io.to(Room.ofDataType(key)).emit(Room.ofDataType(key), json);
  }

  public onDataChanged(key: string, json: string): void {
    this.io.to(Room.ofDataType(key)).emit(Room.ofDataType(key), json);
  }

  public onDataRemoved(key: string): void {
    this.urlRemoved(key);
    this.io.to(Room.ofDataType(key)).emit(Room.ofDataType(key), '');
  }

  private urlAdded(key: string): void {
    this.knownUrls.push(key);
    this.knownUrls.sort((a, b) => {
      if (a < b) {
        return -1;
      }
      if (a > b) {
        return 1;
      }
      return 0;
    });
    this.io.to(Room.URLS).emit(Room.URLS, JSON.stringify(this.knownUrls));
  }

  private urlRemoved(key: string): void {
    const index = this.knownUrls.indexOf(key);
    if (index >= 0) {
      this.knownUrls.splice(index, 1);
    }
    this.io.to(Room.URLS).emit(Room.URLS, JSON.stringify(this.knownUrls));
  }

  private registerApiUrls(key: string) {
    console.log('Register: /api/v1/' + key);
    const router = express.Router();
    router.get('/' + key, (req: any, res: any) => {
      res.json(this.getCurrentApiEntry(key));
    });
    this.app.use('/api/v1', router);
  }
}
