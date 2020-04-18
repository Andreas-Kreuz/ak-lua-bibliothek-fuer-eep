export class WsEvent {
  constructor(public room: string,
              public action: string,
              public payload?: any) {
  }
}
