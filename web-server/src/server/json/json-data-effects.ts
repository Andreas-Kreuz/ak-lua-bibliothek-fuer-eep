import express = require('express');
import { Server, Socket } from 'socket.io';

import { RoomEvent, ServerStatusEvent } from 'web-shared';
import SocketService from '../clientio/socket-service';
import EepDataReducer from './json-data-reducer';
import EepEvent from './eep-event';
import { CacheService } from '../eep/cache-service';
// import TrainRoomObserver from './observers/train/train-room-effects';
import StateObserver from './observers/state-observer';
import JsonApiRoomObserver from './observers/json-data/json-api-room-observer';

export default class EepDataEffects {
  private debug = false;
  private store = new EepDataReducer(this);
  private stateObservers: StateObserver[] = [];
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
    this.addStateObserver(new JsonApiRoomObserver(app, router, io, cacheService));
    // this.addStateObserver(new TrainRoomObserver(io));

    setInterval(() => this.refreshStateIfRequired(), 50);
  }

  private socketConnected(socket: Socket) {
    socket.on(RoomEvent.JoinRoom, (rooms: { room: string }) => {
      const room = rooms.room;
      if (this.debug) console.log('EMIT ' + ServerStatusEvent.Room + ' to interested parties');
      for (const obs of this.stateObservers) {
        obs.onJoinRoom(socket, room);
      }

      // Send JsonKeys to all JsonKey rooms
      if (room === ServerStatusEvent.Room) {
        if (this.debug) console.log('EMIT ' + ServerStatusEvent.CounterUpdated + ' to ' + socket.id);
        socket.emit(ServerStatusEvent.CounterUpdated, JSON.stringify(this.store.getEventCounter()));
      }
    });
  }

  addStateObserver(roomObserver: StateObserver) {
    this.stateObservers.push(roomObserver);
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
      const event: EepEvent = JSON.parse(jsonString);
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
        console.log('STATE expected: ' + expectedEventNr + ' / State received: ' + receivedEventNr);
      }
    } catch (e) {
      console.error(jsonString.length, jsonString.substr(0, 20));
      console.error(e);
    }
  }

  announceStateChange(): void {
    // Inform all observers about state changes
    for (const observer of this.stateObservers) {
      observer.onStateChange(this.store as Readonly<EepDataReducer>);
    }
  }
}
