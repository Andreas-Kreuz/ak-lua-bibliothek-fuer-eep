import { Action, createAction, props } from '@ngrx/store';

export const ROOM = '[AvailableDataTypes]';
export const setDataTypes = createAction(ROOM + ' Set', props<{ types: string[] }>());
