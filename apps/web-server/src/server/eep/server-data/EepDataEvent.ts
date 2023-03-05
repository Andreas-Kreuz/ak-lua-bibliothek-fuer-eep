export default interface EepDataEvent {
  type: 'CompleteReset' | 'DataAdded' | 'DataChanged' | 'DataRemoved' | 'ListChanged';
  payload: undefined;
  eventCounter: number;
}
