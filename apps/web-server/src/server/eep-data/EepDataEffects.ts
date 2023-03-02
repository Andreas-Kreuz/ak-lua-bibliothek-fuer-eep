import SocketService from '../clientio/SocketService';
import { CacheService } from '../eep-service/CacheService';
import EepDataEvent from './EepDataEvent';
import EepDataReducer from './EepDataStore';
import EepDataUpdateService from './observers/EepDataUpdateService';
import JsonApiRoomObserver from './observers/json-data/JsonApiUpdateService';
import PublicTransportService from './observers/public-transport/PublicTransportService';
import TrainUpdateService from './observers/train/TrainUpdateService';
import { RoomEvent, ServerStatusEvent } from '@ak/web-shared';
import express from 'express';
import { Server, Socket } from 'socket.io';

export default class EepDataEffects {
  private debug = false;
  private store = new EepDataReducer(this);
  private stateController: EepDataUpdateService;
  private jsonApiController: JsonApiRoomObserver;
  private refreshSettings = { pending: true, inProgress: false };

  constructor(
    private app: express.Express,
    private router: express.Router,
    private io: Server,
    private socketService: SocketService,
    private cacheService: CacheService
  ) {
    this.store.init(this.cacheService.readCache());
    console.log('STORE INITIALIZED FROM ' + (this.store.currentState().eventCounter + 1) + ' events');

    this.socketService.addOnSocketConnectedCallback((socket: Socket) => this.socketConnected(socket));
    this.stateController = new EepDataUpdateService(io);
    this.jsonApiController = new JsonApiRoomObserver(app, router, io, cacheService);

    // Register the state observers, which will fill all rooms according to their needs
    this.stateController.registerFeatureService(new TrainUpdateService(io));
    this.stateController.registerFeatureService(new PublicTransportService(io));

    setInterval(() => this.refreshStateIfRequired(), 50);
  }

  private socketConnected(socket: Socket) {
    socket.on(RoomEvent.JoinRoom, (rooms: { room: string }) => {
      const room = rooms.room;
      if (this.debug) console.log('EMIT ' + ServerStatusEvent.Room + ' to interested parties');
      this.jsonApiController.onJoinRoom(socket, room);
      this.stateController.onJoinRoom(socket, room);

      // Send JsonKeys to all JsonKey rooms
      if (room === ServerStatusEvent.Room) {
        if (this.debug) console.log('EMIT ' + ServerStatusEvent.CounterUpdated + ' to ' + socket.id);
        socket.emit(ServerStatusEvent.CounterUpdated, JSON.stringify(this.store.getEventCounter()));
      }
    });
  }

  refreshStateIfRequired() {
    if (this.refreshSettings.pending === true && this.refreshSettings.inProgress === false) {
      this.refreshSettings.inProgress = true;
      this.announceStateChange();
      this.refreshSettings.inProgress = false;
      this.refreshSettings.pending = false;
    }
  }

  onNewEventLine(jsonString: string) {
    try {
      const event: EepDataEvent = JSON.parse(jsonString);
      const expectedEventNr = this.store.currentState().eventCounter + 1;
      const receivedEventNr = event.eventCounter;

      // Fire this event only if it is expected or a complete reset
      if (receivedEventNr == 1 || expectedEventNr == receivedEventNr || event.type === 'CompleteReset') {
        this.store.onNewEvent(event);
        this.refreshSettings.pending = true;
      } else if (receivedEventNr > expectedEventNr) {
        console.error(
          'STATE OUT OF SYNC: Expected next event: ' + expectedEventNr + ' / Received Event: ' + receivedEventNr
        );
      } else {
        if (this.debug) console.log('STATE expected: ' + expectedEventNr + ' / State received: ' + receivedEventNr);
      }
    } catch (e) {
      console.error(jsonString.length, jsonString.substr(0, 20));
      console.error(e);
    }
  }

  announceStateChange(): void {
    // Inform all observers about state changes
    try {
      this.jsonApiController.onStateChange(this.store as Readonly<EepDataReducer>);
      this.stateController.onStateChange(this.store as Readonly<EepDataReducer>);
    } catch (e) {
      console.error(e);
      throw e;
    }
  }
}
