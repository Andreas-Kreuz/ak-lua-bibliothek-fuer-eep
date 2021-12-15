import cors = require('cors');
import { EventEmitter } from 'events';
import express from 'express';
import path from 'path';
import { createServer } from 'http';
import { Server } from 'socket.io';

import AppEffects from './app/app-effects';
import SocketService from './clientio/socket-service';

const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer, {
  cors: {
    origin: ['http://localhost:4200', 'http://jens-pc:4200'],
    methods: ['GET', 'POST'],
  },
});
const router = express.Router();

export class ServerMain {
  private appEffects: AppEffects;
  private socketService: SocketService;

  constructor(private serverConfigPath: string, private port = 3000) {
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
    httpServer.listen(this.port, () => {
      console.log('Express server listening on port ' + app.get('port'));
    });
    this.appEffects = new AppEffects(app, router, io, this.socketService, this.serverConfigPath);
    this.appEffects.changeEepDirectory(this.appEffects.getEepDirectory());
  }
}
