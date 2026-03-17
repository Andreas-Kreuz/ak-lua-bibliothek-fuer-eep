import { DataChangePayload } from './DataChangePayload';
import { ListChangePayload } from './ListChangePayload';

export default interface EepDataEvent {
  type: 'CompleteReset' | 'DataAdded' | 'DataChanged' | 'DataRemoved' | 'ListChanged';
  payload: DataChangePayload<unknown> | ListChangePayload<unknown> | undefined;
  eventCounter: number;
}
