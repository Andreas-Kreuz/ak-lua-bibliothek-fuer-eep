import cors = require('cors');
import express = require('express');
import http = require('http');
import path from 'path';
import socketio from 'socket.io';

import AppEffects from './app/app-effects';
import SocketService from './clientio/socket-manager';

const app = express();
const server = new http.Server(app);
const io = socketio(server);

export class ServerMain {
  private appEffects: AppEffects;
  private socketService: SocketService;

  constructor(private port = 3000) {
    // Init the server
    app.use(cors());
    app.set('port', this.port);
    this.socketService = new SocketService(io);
    this.appEffects = new AppEffects(app, io, this.socketService);
  }

  public start() {
    app.use('/', express.static(path.join(__dirname, '../public_html')));
    server.listen(this.port, () => {
      console.log('Express server listening on port ' + app.get('port'));
    });
    this.appEffects.changeEepDirectory(this.appEffects.getEepDirectory());
  }
}
