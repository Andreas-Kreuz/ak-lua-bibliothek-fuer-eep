import { createAction, props } from '@ngrx/store';
import { LuaSetting, LuaSettings } from 'web-shared/build/model/settings';
import { DynamicRoom } from 'web-shared/build/rooms';
import { LineListEntry, StationListEntry } from 'web-shared/build/model/public-transport';

export const initModule = createAction('Public Transport InitModule');
export const destroyModule = createAction('Public Transport DestroyModule');
export const enterRoom = createAction('Public Transport Enter Room', props<{ room: DynamicRoom }>());
export const leaveRoom = createAction('Public Transport Leave Room', props<{ room: DynamicRoom }>());
export const settingsUpdated = createAction(
  'Public Transport Settings Updated',
  props<{ moduleSettings: LuaSettings }>()
);
export const settingChanged = createAction(
  'Public Transport Setting Changed',
  props<{ setting: LuaSetting<unknown>; value: unknown }>()
);
export const lineListUpdated = createAction('Public Transport Lines Updated', props<{ lineList: LineListEntry[] }>());
export const stationListUpdated = createAction(
  'Public Transport Stations Updated',
  props<{ stationList: StationListEntry[] }>()
);
