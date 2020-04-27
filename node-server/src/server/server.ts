export class Server {
  constructor() {}

  public start() {
    'use strict';
    const express = require('express');
    const app = express();
    const port = 3000;

    app.use('/', express.static(__dirname + '/../../../web-app/dist/ak-eep-web'));

    // registerJsonUrls();
    // app.get('/', function(req, res) {
    //    res.send("Hello world! Lala Seth is here!");
    // });
    const server = app.listen(port, () => {
      console.log('Express server listening on port ' + server.address().port);
    });
    module.exports = app;
  }
}
