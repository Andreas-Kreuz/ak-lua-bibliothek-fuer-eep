import SocketService from '../../clientio/SocketService';
import PublicTransportService from '../../mod/public-transport/PublicTransportService';
import TrainUpdateService from '../../mod/train/TrainUpdateService';
import { CacheService } from './CacheService';
import EepDataEvent from './EepDataEvent';
import EepDataReducer from './EepDataStore';
import DynamicRoomManager from './dynamic/DynamicRoomManager';
import DynamicRoomService from './dynamic/DynamicRoomService';
import JsonApiRoomObserver from './static/JsonApiUpdateService';
import { RoomEvent, ServerStatusEvent } from '@ak/web-shared';
import express from 'express';
import { Server, Socket } from 'socket.io';

export default class EepDataEffects {
  private debug = false;
  private store = new EepDataReducer();
  private stateController: DynamicRoomManager;
  private jsonApiController: JsonApiRoomObserver;
  private refreshSettings = { pending: true, inProgress: false };

  constructor(
    router: express.Router,
    io: Server,
    private socketService: SocketService,
    private cacheService: CacheService
  ) {
    this.store.init(this.cacheService.readCache());
    console.log('STORE INITIALIZED FROM ' + (this.store.currentState().eventCounter + 1) + ' events');

    this.socketService.addOnSocketConnectedCallback((socket: Socket) => this.socketConnected(socket));
    this.stateController = new DynamicRoomManager(io);
    this.jsonApiController = new JsonApiRoomObserver(router, io, cacheService);

    setInterval(() => this.refreshStateIfRequired(), 50);
  }

  registerDynamicRoom(dynamicRoomService: DynamicRoomService) {
    this.stateController.registerService(dynamicRoomService);
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
