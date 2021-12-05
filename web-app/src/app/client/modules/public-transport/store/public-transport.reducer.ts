import { createFeatureSelector, createSelector, createReducer, Action, on, createFeature } from '@ngrx/store';
import * as PublicTransportActions from './public-transport.actions';
import { PublicTransportLineListEntry, PublicTransportStationListEntry } from 'web-shared/build/model/public-transport';
import { LuaSettings } from 'web-shared/build/model/settings';

export interface State {
  moduleSettings: LuaSettings;
  lineList: PublicTransportLineListEntry[];
  stationList: PublicTransportStationListEntry[];
}

const initialState: State = {
  moduleSettings: new LuaSettings('Unknown', []),
  lineList: [],
  stationList: [],
};

const publicTransportReducer = createReducer(
  initialState,
  on(PublicTransportActions.settingsUpdated, (state: State, { moduleSettings }) => ({
    ...state,
    moduleSettings,
  })),
  on(PublicTransportActions.lineListUpdated, (state: State, { lineList }) => ({
    ...state,
    lineList,
  })),
  on(PublicTransportActions.stationListUpdated, (state: State, { stationList }) => ({
    ...state,
    stationList,
  }))
);

export const publicTransportFeature = createFeature({ name: 'public-transport', reducer: publicTransportReducer });
