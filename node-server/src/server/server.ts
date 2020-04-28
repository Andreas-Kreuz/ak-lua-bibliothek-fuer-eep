export class Server {
  constructor(
    private express = require('express'),
    private app = express(),
    private port = 3000,
    private lastContents: { [key: string]: any[] } = {}
  ) {
    const cors = require('cors');
    this.app.use(cors());
  }

  public start() {
    'use strict';
    this.app.use('/', this.express.static(__dirname + '/../../../web-app/dist/ak-eep-web'));

    // registerJsonUrls();
    // app.get('/', function(req, res) {
    //    res.send("Hello world! Lala Seth is here!");
    // });
    this.onUpdate('{ "test": [{ "key": 1, "value": true }] }');

    const server = this.app.listen(this.port, () => {
      console.log('Express server listening on port ' + server.address().port);
    });
  }

  /**
   * This will fill the API and send Socket Events to all listeners
   * @param jsonString JsonString from EEP
   */
  private onUpdate(jsonString: string) {
    const contents: { [key: string]: any[] } = JSON.parse(jsonString);

    for (const key in contents) {
      if (contents.hasOwnProperty(key)) {
        const list: any[] = contents[key];
        this.registerApiUrl(key, list);
      }
    }
  }

  private registerApiUrl(key: string, list: any) {
    this.app.get('/api/v1/' + key, (req: any, res: { json: (arg0: string) => void }, next: any) => {
      res.json(list);
    });
  }
}
