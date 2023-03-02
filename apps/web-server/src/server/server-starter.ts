import { app, BrowserWindow, shell } from 'electron';
import * as path from 'path';
import { ServerMain } from './server-main';

console.log('Server will start');
const server = new ServerMain(path.resolve(app.getPath('appData'), 'eep-web-server'));
server.start();
console.log('Server was started');