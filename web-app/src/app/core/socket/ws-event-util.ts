import { WsEvent } from './ws-event';

export class WsEventUtil {
  public static storeAction(w: WsEvent) {
    return w.action;
  }
}
