import electron = require('electron');
import express = require('express');
import fs from 'fs';
import path from 'path';
import { performance } from 'perf_hooks';
import { Server, Socket } from 'socket.io';

import { RoomEvent, ServerInfoEvent, SettingsEvent } from 'web-shared';
import SocketService from '../clientio/socket-service';
import CommandEffects from '../command/command-effects';
import EepService from '../eep/eep-service';
import IntersectionEffects from '../intersection/intersection-effects';
import JsonDataEffects from '../json/json-data-effects';
import LogEffects from '../log/log-effects';
import AppConfig from './app-config';
import AppReducer from './app-reducer';
import { ServerStatisticsService } from './app-statistics.service';

export default class AppEffects {
  private serverConfigPath = path.resolve(electron.app.getPath('appData'), 'eep-web-server');
  private serverConfigFile = path.resolve(this.serverConfigPath, 'settings.json');
  private jsonDataEffects: JsonDataEffects;
  private logEffects: LogEffects;
  private intersectionEffects: IntersectionEffects;
  private commandEffects: CommandEffects;
  private store = new AppReducer(this);

  // Statistic data
  private statistics: ServerStatisticsService;

  constructor(
    private app: any,
    private router: express.Router,
    private io: Server,
    private socketService: SocketService
  ) {
    // Start collecting statistic data
    this.statistics = new ServerStatisticsService();
    this.statistics.start();

    this.loadConfig();
    this.socketService.addOnSocketConnectedCallback((socket: Socket) => this.socketConnected(socket));
  }

  private socketConnected(socket: Socket) {
    socket.on(RoomEvent.JoinRoom, (rooms: { room: string }) => {
      if (rooms.room === SettingsEvent.Room) {
        const event = this.store.getEepDirOk() ? SettingsEvent.DirOk : SettingsEvent.DirError;
        console.log('EMIT ' + event + ' to ' + socket.id + this.getEepDirectory());
        socket.emit(SettingsEvent.Dir, this.getEepDirectory());
        socket.emit(event, this.getEepDirectory());
      }

      if (rooms.room === ServerInfoEvent.Room) {
        socket.emit(ServerInfoEvent.StatisticsUpdate, this.statistics);
      }
    });

    socket.on(SettingsEvent.ChangeDir, (dir: string) => {
      console.log(SettingsEvent.ChangeDir + '"' + dir + '"');
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
      }
      if (dir) {
        console.log('Directory set to : ' + dir);
        this.registerHandlers(fileOperations);
        this.store.setEepDirOk(true);
        this.saveEepDirectory(eepDir);
        this.io.to(SettingsEvent.Room).emit(SettingsEvent.DirOk, eepDir);
      } else {
        this.store.setEepDirOk(false);
        this.saveEepDirectory(eepDir);
        this.io.to(SettingsEvent.Room).emit(SettingsEvent.DirError, eepDir);
      }
    });
  }

  private registerHandlers(eepService: EepService) {
    // Init JsonHandler
    this.jsonDataEffects = new JsonDataEffects(this.app, this.router, this.io, this.socketService);
    eepService.setOnJsonContentChanged((jsonString: string, lastJsonUpdate: number) => {
      performance.mark('json-parsing:before');
      this.jsonDataEffects.jsonDataUpdated(jsonString); // The real stuff
      performance.mark('json-parsing:after');
      performance.measure(ServerStatisticsService.TimeForJsonParsing, 'json-parsing:before', 'json-parsing:after');
      this.statistics.setLastEepTime(lastJsonUpdate);
    });

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
