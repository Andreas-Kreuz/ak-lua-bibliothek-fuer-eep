import { ServerMain } from './ServerMain';
import APP_IDENTIFIER from './config/AppIdentifier';
import { app } from 'electron';
import * as path from 'path';

console.log('Server will start');
const server = new ServerMain(path.resolve(app.getPath('appData'), APP_IDENTIFIER));
server.start();
console.log('Server was started');
