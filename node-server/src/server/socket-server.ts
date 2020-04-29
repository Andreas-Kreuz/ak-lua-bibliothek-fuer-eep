export default class SocketServer {
  constructor(private io: any) {
    this.registerMessages();
  }

  private registerMessages() {
    this.io.on('connection', (socket: any) => {
      console.log('a user connected');
    });
  }

  public addJsonRoom(key: string): void {}
  public informJsonRoom(key: string): void {}
  public removeJsonRoom(key: string): void {}
}
