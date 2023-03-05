// KEEP THIS FILE FOR HEADLESS TESTS
// See in node ./build/node-main.js --testmode --exchange-dir ../web-app-react/cypress/io package.json
import { ServerMain } from './ServerMain';

const server = new ServerMain('.');
server.start();
