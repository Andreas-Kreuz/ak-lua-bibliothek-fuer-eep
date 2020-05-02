export class DataEvent {
  static roomOf(dataType: string): string {
    return '[Data ' + dataType + ']';
  }

  static eventOf(dataType: string): string {
    return '[Data Event ' + dataType + '] Set';
  }
}
