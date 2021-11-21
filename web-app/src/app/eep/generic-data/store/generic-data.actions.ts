import { createAction, props } from '@ngrx/store';
import { DataType } from 'web-shared';

export const fetchDataTypes = createAction('[Generic Data] Fetch data types', props<{ payload: string }>());
export const setDataTypes = createAction('[Generic Data] Set data types', props<{ dataTypes: DataType[] }>());
export const fetchData = createAction(
  '[Generic Data] Fetch Data',
  props<{
    name: string;
    hostName: string;
    path: string;
  }>()
);
export const updateData = createAction(
  '[Generic Data] Set Data',
  props<{ dataType: string; values: Record<string, unknown> }>()
);
