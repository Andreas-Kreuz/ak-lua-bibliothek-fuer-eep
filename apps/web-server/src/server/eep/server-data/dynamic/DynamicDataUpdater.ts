import * as fromJsonData from '../EepDataStore';

export interface DynamicDataUpdater {
  updateFromState: (state: Readonly<fromJsonData.State>) => void;
}
