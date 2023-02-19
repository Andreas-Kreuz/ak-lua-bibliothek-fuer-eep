import * as cors from 'cors';
import * as express from 'express';
import * as path from 'path';
import { EventEmitter } from 'events';
import { createServer } from 'http';
import { Server } from 'socket.io';

import AppEffects from './app/app-effects';
import SocketService from './clientio/socket-service';
import { networkInterfaces } from 'os';

const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer, {
  cors: {
    origin: [
      'http://localhost:3001',
      'http://localhost:4200',
      'http://localhost:5173',
      'http://127.0.0.1:3001',
      'http://127.0.0.1:4200',
      'http://127.0.0.1:5173',
      'http://jens-pc:3001',
      'http://jens-pc:4200',
      'http://jens-pc:5173',
    ],
    credentials: false,
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
    console.log('Starting Server with ' + this.serverConfigPath);
    const appDir = path.join(__dirname, '../public_html');
    app.use('/api/v1', router);
    app.use(function (req, res, next) {
      res.setHeader('Cache-Control', 'public, max-age=86400');
      return next();
    });
    app.use('/', express.static(appDir));
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    app.get('/*', (req: any, res: any) => {
      res.sendFile(path.join(appDir, '/index.html'));
    });
    httpServer.listen(this.port, () => {
      console.log('Express server listening on port ' + app.get('port') + ' ## ' + this.serverConfigPath);
    });
    this.appEffects = new AppEffects(app, router, io, this.socketService, this.serverConfigPath);
    this.appEffects.changeEepDirectory(this.appEffects.getEepDirectory());
  }
}
