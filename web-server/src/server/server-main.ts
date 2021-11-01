import cors = require('cors');
import { EventEmitter } from 'events';
import express = require('express');
import http = require('http');
import path from 'path';
import socketio from 'socket.io';

import AppEffects from './app/app-effects';
import SocketService from './clientio/socket-service';

const app = express();
const router = express.Router();
const server = new http.Server(app);
const io = socketio(server);

export class ServerMain {
  private appEffects: AppEffects;
  private socketService: SocketService;

  constructor(private port = 3000) {
    // Init the server
    EventEmitter.defaultMaxListeners = 50;
    app.use(cors());
    app.set('port', this.port);
    this.socketService = new SocketService(io);
  }

  public start() {
    const appDir = path.join(__dirname, '../public_html');
    app.use('/api/v1', router);
    app.use('/', express.static(appDir));
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    app.get('/*', (req: any, res: any) => {
      res.sendFile(path.join(appDir, '/index.html'));
    });
    server.listen(this.port, () => {
      console.log('Express server listening on port ' + app.get('port'));
    });
    this.appEffects = new AppEffects(app, router, io, this.socketService);
    this.appEffects.changeEepDirectory(this.appEffects.getEepDirectory());
  }
}
