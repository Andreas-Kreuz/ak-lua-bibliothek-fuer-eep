import { Action, createAction, props } from '@ngrx/store';

export const setDataTypes = createAction('[Datatypes] Changed', props<{ types: string[] }>());
