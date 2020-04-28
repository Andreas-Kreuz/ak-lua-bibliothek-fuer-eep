import { json, Router } from 'express';
import FileOperations from './file-operations';
import JsonDataHandler from './json-data-handler';

export class Server {
  private jsonDataHandler: JsonDataHandler;

  constructor(
    private express = require('express'),
    private app = express(),
    private port = 3000,
    private fileOperations = new FileOperations()
  ) {
    const cors = require('cors');
    this.app.use(cors());

    // Init JsonHandler
    this.jsonDataHandler = new JsonDataHandler(
      (key: string) => this.jsonKeyAdded(key),
      (key: string) => this.jsonKeyChanged(key),
      (key: string) => this.jsonKeyRemoved(key)
    );
    fileOperations.onJsonContentChanged((jsonString: string) => this.jsonDataHandler.jsonDataUpdated(jsonString));

    // Init LogHandler
    // fileOperations.addLogCallback((jsonString: string) => this.onUpdate);
  }

  public start() {
    'use strict';
    this.app.use('/', this.express.static(__dirname + '/../../../web-app/dist/ak-eep-web'));
    const server = this.app.listen(this.port, () => {
      console.log('Express server listening on port ' + server.address().port);
    });
  }

  public jsonKeyRemoved(key: string) {
    // this.removeRoom(key);
  }

  public jsonKeyChanged(key: string) {
    // this.informRoom(key);
  }

  public jsonKeyAdded(key: string) {
    this.registerApiUrls(key);
    // this.addRoom(key);
  }

  private registerApiUrls(key: string) {
    console.log('Register: /api/v1/: ' + key);
    const router = this.express.Router();
    router.get('/' + key, (req: any, res: any) => {
      res.json(this.jsonDataHandler.getCurrentApiEntry(key));
    });
    this.app.use('/api/v1', router);
  }
}
