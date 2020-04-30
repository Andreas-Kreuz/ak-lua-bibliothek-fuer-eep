import path from 'path';
import FileOperations from './file-operations';
import JsonDataManager from './json-data-handler';
import SocketManager from './socket-manager';

import cors = require('cors');
import express = require('express');
import fs from 'fs';
import http = require('http');
import socketio, { Socket } from 'socket.io';
import Config from './config';
import Room from './room';
import SocketEvent from './socket-event';

const app = express();
const server = new http.Server(app);
const io = socketio(server);

export class ServerMain {
  private config = new Config();
  private jsonDataHandler: JsonDataManager;
  private socketMgr: SocketManager;

  constructor(private port = 3000) {
    // Init the server
    app.use(cors());
    app.set('port', this.port);
    this.socketMgr = new SocketManager(io);
    this.socketMgr.addOnRoomsJoinedCallback((socket: Socket, joinedRooms: string[]) => this.onRoomsJoined(socket, joinedRooms));
  }

  public changeEepDirectory(eepDir: string) {
    // Append the exchange directory to the path
    const dir = path.resolve(eepDir, 'LUA/ak/io/exchange/');

    // Check the directory and register handlers on success
    const fileOperations = new FileOperations();
    fileOperations.reInit(dir, (err: string, dir2: string) => {
      if (err) {
        console.error(err);
        io.to(Room.SERVER_SETTINGS).emit('[Current Dir]', err);
      } else if (dir2) {
        this.config.saveEepDirectory(eepDir);
        console.log('Directory set to : ' + dir2);
        this.registerHandlers(fileOperations);
        io.to(Room.SERVER_SETTINGS).emit('[Current Dir]', eepDir);
      }
    });
  }

  private registerHandlers(fileOperations: FileOperations) {
    // Init JsonHandler
    this.jsonDataHandler = new JsonDataManager(app, io, this.socketMgr);
    fileOperations.setOnJsonContentChanged((jsonString: string) => this.jsonDataHandler.jsonDataUpdated(jsonString));

    // Init LogHandler
    // fileOperations.addLogCallback((jsonString: string) => this.onUpdate);
  }

  public start() {
    app.use('/', express.static(path.join(__dirname, '../public_html')));
    server.listen(this.port, () => {
      console.log('Express server listening on port ' + app.get('port'));
    });
    this.changeEepDirectory(this.config.getEepDirectory());
  }

  onRoomsJoined(socket: Socket, joinedRooms: string[]) {
    if (joinedRooms.indexOf(Room.SERVER_SETTINGS) > -1) {
      console.log('EMIT ' + '[Current Dir]' + ' to ' + socket.id);
      socket.emit('[Current Dir]', this.config.getEepDirectory());
    }
  }
}
