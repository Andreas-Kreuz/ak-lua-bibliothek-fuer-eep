import { createAction, props } from '@ngrx/store';
import TimeDesc from './time-desc';

export const serverControllerUpdate = createAction(
  '[Statistics] LUA Server Controller Update',
  props<{ times: TimeDesc[] }>()
);

export const dataInitializeUpdate = createAction(
  '[Statistics] LUA Data Initialize Update',
  props<{ times: TimeDesc[] }>()
);

export const dataCollectorUpdate = createAction(
  '[Statistics] LUA Data Collector Update',
  props<{ times: TimeDesc[] }>()
);
