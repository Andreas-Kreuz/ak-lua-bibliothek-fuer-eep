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
  private eepDirOk = false;

  constructor(private port = 3000) {
    // Init the server
    app.use(cors());
    app.set('port', this.port);
    this.socketMgr = new SocketManager(io);
    this.socketMgr.addOnRoomsJoinedCallback((socket: Socket, joinedRooms: string[]) =>
      this.onRoomsJoined(socket, joinedRooms)
    );
    io.on('connection', (socket: Socket) => {
      socket.on(SocketEvent.ChangeDir, (dir: string) => {
        console.log(SocketEvent.ChangeDir + '"' + dir + '"');
        this.changeEepDirectory(dir);
      });
    });
  }

  public changeEepDirectory(eepDir: string) {
    // Append the exchange directory to the path
    const completeDir = path.resolve(eepDir, 'LUA/ak/io/exchange/');

    // Check the directory and register handlers on success
    const fileOperations = new FileOperations();
    fileOperations.reInit(completeDir, (err: string, dir: string) => {
      if (err) {
        console.error(err);
        this.eepDirOk = false;
        io.to(Room.SERVER_SETTINGS).emit(SocketEvent.DirError, eepDir);
      } else if (dir) {
        this.config.saveEepDirectory(eepDir);
        console.log('Directory set to : ' + dir);
        this.registerHandlers(fileOperations);
        this.eepDirOk = true;
        io.to(Room.SERVER_SETTINGS).emit(SocketEvent.DirOk, eepDir);
      } else {
        this.eepDirOk = false;
        io.to(Room.SERVER_SETTINGS).emit(SocketEvent.DirError, eepDir);
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
      const event = this.eepDirOk ? SocketEvent.DirOk : SocketEvent.DirError;
      console.log('EMIT ' + event + ' to ' + socket.id);
      socket.emit(event, this.config.getEepDirectory());
    }
  }
}
