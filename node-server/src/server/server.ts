import express from 'express';
import path from 'path';
import socketio from 'socket.io';
import FileOperations from './file-operations';
import JsonDataHandler from './json-data-handler';
import SocketServer from './socket-server';

export class Server {
  private jsonDataHandler: JsonDataHandler;
  private app: any;
  private http: any;
  private io: any;
  private socketServer: SocketServer;
  private knownUrls: string[] = [];

  constructor(
    private exchangeDir = path.resolve(__dirname + '/../../../lua/LUA/ak/io/exchange/'),
    private port = 3000
  ) {
    // Init the server
    this.app = express();
    const cors = require('cors');
    this.app.use(cors());
    this.app.set('port', this.port);
    this.http = require('http').Server(this.app);
    this.io = socketio(this.http);

    this.socketServer = new SocketServer(this.io);

    // Init file operations
    const fileOperations = new FileOperations(this.exchangeDir);

    // Init JsonHandler
    this.jsonDataHandler = new JsonDataHandler(
      (key: string) => this.jsonKeyAdded(key),
      (key: string) => this.jsonKeyChanged(key),
      (key: string) => this.jsonKeyRemoved(key)
    );
    fileOperations.setOnJsonContentChanged((jsonString: string) => this.jsonDataHandler.jsonDataUpdated(jsonString));

    // Init LogHandler
    // fileOperations.addLogCallback((jsonString: string) => this.onUpdate);
  }

  public start() {
    'use strict';
    this.app.use('/', express.static(__dirname + '/../../../web-app/dist/ak-eep-web'));
    const server = this.http.listen(this.port, () => {
      console.log('Express server listening on port ' + server.address().port);
    });
  }

  public jsonKeyRemoved(key: string): void {
    this.urlRemoved(key);
    this.socketServer.removeJsonRoom(key);
  }

  public jsonKeyChanged(key: string): void {
    this.socketServer.informJsonRoom(key);
  }

  public jsonKeyAdded(key: string): void {
    this.urlAdded(key);
    this.registerApiUrls(key);
    this.socketServer.addJsonRoom(key);
  }

  private urlRemoved(key: string): void {
    this.knownUrls.splice(this.knownUrls.indexOf(key));
    this.io.emit('urls', this.knownUrls);
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
    this.io.emit('urls', JSON.stringify(this.knownUrls));
  }

  private registerApiUrls(key: string) {
    console.log('Register: /api/v1/' + key);
    const router = express.Router();
    router.get('/' + key, (req: any, res: any) => {
      res.json(this.jsonDataHandler.getCurrentApiEntry(key));
    });
    this.app.use('/api/v1', router);
  }
}
