import CommandLineParser from '../CommandLineParser';
import SocketService from '../clientio/SocketService';
import CommandEffects from '../command/CommandEffects';
import EepDataEffects from '../eep-data/EepDataEffects';
import { CacheService } from '../eep-service/CacheService';
import EepService from '../eep-service/EepService';
import IntersectionEffects from '../intersection/IntersectionEffects';
import LogEffects from '../log/LogEffects';
import AppConfig from './AppConfig';
import AppReducer from './AppData';
import { ServerStatisticsService } from './ServerStatisticsService';
import { RoomEvent, ServerInfoEvent, SettingsEvent } from '@ak/web-shared';
import * as express from 'express';
import * as fs from 'fs';
import * as path from 'path';
import { performance } from 'perf_hooks';
import { Server, Socket } from 'socket.io';

export default class AppEffects {
  private debug = true;
  private serverConfigFile: string;
  private eepDataEffects: EepDataEffects;
  private logEffects: LogEffects;
  private commandEffects: CommandEffects;
  private intersectionEffects: IntersectionEffects;
  private store = new AppReducer();
  private TESTMODE = false;

  // Statistic data
  private statistics: ServerStatisticsService;

  constructor(
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    private app: any,
    private router: express.Router,
    private io: Server,
    private socketService: SocketService,
    private serverConfigPath: string
  ) {
    this.serverConfigFile = path.resolve(this.serverConfigPath, 'settings.json');

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
        if (this.debug) console.log('EMIT ' + event + ' to ' + socket.id, this.getEepDirectory());
        socket.emit(event, this.getEepDirectory());
        if (this.debug) console.log('EMIT ' + SettingsEvent.Host + ' to ' + socket.id, this.getHostname());
        socket.emit(SettingsEvent.Host, this.getHostname());
      }

      if (rooms.room === ServerInfoEvent.Room) {
        socket.emit(ServerInfoEvent.StatisticsUpdate, this.statistics);
      }
    });

    socket.on(SettingsEvent.ChangeDir, (dir: string) => {
      if (this.debug) console.log(SettingsEvent.ChangeDir + '"' + dir + '"');
      this.changeEepDirectory(dir);
    });
  }

  private loadConfig(): void {
    let appConfig = new AppConfig();
    try {
      const options = new CommandLineParser().parseOptions();
      appConfig.eepDir = path.resolve(options['exchange-dir'] || '../web-app/cypress/io');
      this.TESTMODE = options.testmode || false;
      if (!this.TESTMODE && fs.statSync(this.serverConfigFile).isFile()) {
        const data = fs.readFileSync(this.serverConfigFile, { encoding: 'utf8' });
        const config = JSON.parse(data);
        appConfig = config;
      }
    } catch (error) {
      console.log(error);
    }
    this.store.setAppConfig(appConfig);
  }

  private saveConfig(config: { eepDir: string }): void {
    if (!this.TESTMODE) {
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
  }

  public getEepDirectory(): string {
    return this.store.getEepDir();
  }

  public getHostname(): string {
    return this.store.getHostname();
  }

  public saveEepDirectory(dir: string): void {
    this.store.setEepDir(dir);
    this.saveConfig(this.store.getAppConfig());
  }

  public changeEepDirectory(eepDir: string) {
    // Append the exchange directory to the path
    const completeDir = path.resolve(eepDir, 'LUA/ak/io/exchange/');

    // Check the directory and register handlers on success
    const eepService = new EepService();
    eepService.reInit(completeDir, (err: string, dir: string) => {
      if (err) {
        console.error(err);
      }
      if (dir) {
        console.log('Directory set to : ' + dir);
        this.registerHandlers(eepService);
        this.store.setEepDirOk(true);
        this.saveEepDirectory(eepDir);
        this.io.to(SettingsEvent.Room).emit(SettingsEvent.DirOk, eepDir);
      } else {
        this.store.setEepDirOk(false);
        this.saveEepDirectory(eepDir);
        this.io.to(SettingsEvent.Room).emit(SettingsEvent.DirError, eepDir);
      }

      if (this.debug) console.log('EMIT ' + SettingsEvent.Host, this.getHostname());
      this.io.to(SettingsEvent.Room).emit(SettingsEvent.Host, this.store.getHostname());
    });
  }

  private registerHandlers(eepService: EepService) {
    this.eepDataEffects = new EepDataEffects(
      this.app,
      this.router,
      this.io,
      this.socketService,
      eepService as CacheService
    );

    // Init event handler
    eepService.setOnNewEventLine((eventLines: string) => {
      this.eepDataEffects.onNewEventLine(eventLines);
    });

    // Init JsonHandler
    eepService.setOnJsonContentChanged((jsonString: string, lastJsonUpdate: number) => {
      performance.mark('json-parsing:before');
      // this.jsonDataEffects.announceState(); // The real stuff
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
