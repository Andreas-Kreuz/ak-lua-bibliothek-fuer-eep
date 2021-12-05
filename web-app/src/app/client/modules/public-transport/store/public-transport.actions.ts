import { createAction, props } from '@ngrx/store';
import { LuaSettings } from 'web-shared/build/model/settings';
import { DynamicRoom } from 'web-shared/build/rooms';
import { PublicTransportLineListEntry, PublicTransportStationListEntry } from 'web-shared/build/model/public-transport';

export const enterRoom = createAction('Public Transport Enter Room', props<{ room: DynamicRoom }>());
export const leaveRoom = createAction('Public Transport Enter Room', props<{ room: DynamicRoom }>());
export const settingsUpdated = createAction(
  'Public Transport Settings Updated',
  props<{ moduleSettings: LuaSettings }>()
);
export const lineListUpdated = createAction(
  'Public Transport Lines Updated',
  props<{ lineList: PublicTransportLineListEntry[] }>()
);
export const stationListUpdated = createAction(
  'Public Transport Stations Updated',
  props<{ stationList: PublicTransportStationListEntry[] }>()
);
