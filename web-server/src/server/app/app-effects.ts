import electron = require('electron');
import fs from 'fs';
import path from 'path';
import { Server, Socket } from 'socket.io';

import { SettingsEvent, RoomEvent } from 'web-shared';
import SocketService from '../clientio/socket-service';
import CommandEffects from '../command/command-effects';
import EepService from '../eep/eep-service';
import IntersectionEffects from '../intersection/intersection-effects';
import JsonDataEffects from '../json/json-data-effects';
import LogEffects from '../log/log-effects';
import AppConfig from './app-config';
import AppReducer from './app-reducer';

export default class AppEffects {
  private serverConfigPath = path.resolve(electron.app.getPath('appData'), 'eep-web-server');
  private serverConfigFile = path.resolve(this.serverConfigPath, 'settings.json');
  private jsonDataEffects: JsonDataEffects;
  private logEffects: LogEffects;
  private intersectionEffects: IntersectionEffects;
  private commandEffects: CommandEffects;
  private store = new AppReducer(this);

  constructor(private app: any, private io: Server, private socketService: SocketService) {
    this.loadConfig();
    this.socketService.addOnSocketConnectedCallback((socket: Socket) => this.socketConnected(socket));
  }

  private socketConnected(socket: Socket) {
    socket.on(RoomEvent.JoinRoom, (rooms: { room: string }) => {
      if (rooms.room === SettingsEvent.Room) {
        const event = this.store.getEepDirOk() ? SettingsEvent.DirOk : SettingsEvent.DirError;
        // console.log('EMIT ' + event + ' to ' + socket.id);
        // console.log('EMIT ' + SocketEvent.Dir + ', ' + this.getEepDirectory() + ' to ' + socket.id);
        socket.emit(event, this.getEepDirectory());
        socket.emit(SettingsEvent.Dir, this.getEepDirectory());
      }
    });

    socket.on(SettingsEvent.ChangeDir, (dir: string) => {
      // console.log(SocketEvent.ChangeDir + '"' + dir + '"');
      this.changeEepDirectory(dir);
    });
  }

  private loadConfig(): void {
    let appConfig = new AppConfig();
    try {
      if (fs.statSync(this.serverConfigFile).isFile()) {
        const data = fs.readFileSync(this.serverConfigFile, { encoding: 'utf8' });
        const config = JSON.parse(data);
        appConfig = config;
      }
    } catch (error) {
      // IGNORE console.log(error);
    }
    this.store.setAppConfig(appConfig);
    this.io.to(SettingsEvent.Room).emit(SettingsEvent.DirError, this.store.getEepDir());
  }

  private saveConfig(config: { eepDir: string }): void {
    try {
      fs.mkdirSync(this.serverConfigPath);
    } catch (error) {
      // IGNORE console.log(error);
    }
    try {
      fs.writeFileSync(this.serverConfigFile, JSON.stringify(config));
    } catch (error) {
      console.log(error);
    }
  }

  public getEepDirectory(): string {
    return this.store.getEepDir();
  }

  public saveEepDirectory(dir: string): void {
    this.store.setEepDir(dir);
    this.saveConfig(this.store.getAppConfig());
  }

  public changeEepDirectory(eepDir: string) {
    // Append the exchange directory to the path
    const completeDir = path.resolve(eepDir, 'LUA/ak/io/exchange/');

    // Check the directory and register handlers on success
    const fileOperations = new EepService();
    fileOperations.reInit(completeDir, (err: string, dir: string) => {
      if (err) {
        console.error(err);
        this.store.setEepDirOk(false);
        this.io.to(SettingsEvent.Room).emit(SettingsEvent.DirError, eepDir);
      } else if (dir) {
        console.log('Directory set to : ' + dir);
        this.registerHandlers(fileOperations);
        this.store.setEepDirOk(true);
        this.saveEepDirectory(eepDir);
        this.io.to(SettingsEvent.Room).emit(SettingsEvent.DirOk);
        this.io.to(SettingsEvent.Room).emit(SettingsEvent.Dir, eepDir);
      } else {
        this.store.setEepDirOk(false);
        this.io.to(SettingsEvent.Room).emit(SettingsEvent.DirError, eepDir);
      }
    });
  }

  private registerHandlers(eepService: EepService) {
    // Init JsonHandler
    this.jsonDataEffects = new JsonDataEffects(this.app, this.io, this.socketService);
    eepService.setOnJsonContentChanged((jsonString: string) => this.jsonDataEffects.jsonDataUpdated(jsonString));

    // Init LogHandler
    this.logEffects = new LogEffects(
      this.app,
      this.io,
      this.socketService,
      eepService.getCurrentLogLines,
      eepService.queueCommand
    );
    eepService.setOnNewLogLine((logLines: string) => this.logEffects.onNewLogLine(logLines));
    eepService.setOnLogCleared(() => this.logEffects.onLogCleared());

    // Init CommandHandler
    this.commandEffects = new CommandEffects(this.app, this.io, this.socketService, eepService.queueCommand);

    // Init IntersectionHandler
    this.intersectionEffects = new IntersectionEffects(this.app, this.io, this.socketService, eepService.queueCommand);
  }
}
