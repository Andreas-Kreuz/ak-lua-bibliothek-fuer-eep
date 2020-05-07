import { SocketEvent } from './socket-event';

export class WsEventUtil {
  // TODO REMOVE THIS
  public static storeAction(w: SocketEvent) {
    return w.action;
  }
}
