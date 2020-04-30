import CommandLineParser from './server/command-line-parser';
import { Server } from './server/server';

// User App Code
const options = new CommandLineParser().parseOptions();
const server = new Server(options['exchange-dir']);
server.start();
