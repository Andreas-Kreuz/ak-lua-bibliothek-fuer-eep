import { Action, createAction, props } from '@ngrx/store';

import { Intersection } from '../models/intersection.model';
import { IntersectionLane } from '../models/intersection-lane.model';
import { IntersectionSwitching } from '../models/intersection-switching.model';
import { IntersectionTrafficLight } from '../models/intersection-traffic-light.model';
import { LuaSetting } from '../../../shared/model/lua-setting';
import { LuaSettings } from '../../../shared/model/lua-settings';

export const setIntersections = createAction(
  '[Intersections] Set Intersections',
  props<{ intersections: Intersection[] }>()
);
export const setModuleSettings = createAction(
  '[Intersections] Set Module Settings',
  props<{ settings: LuaSettings }>()
);
export const changeModuleSettings = createAction(
  '[Intersections] Send Module Setting Update',
  props<{ setting: LuaSetting<any>; value: any }>()
);
export const setLanes = createAction('[Intersections] Set Lanes', props<{ lanes: IntersectionLane[] }>());
export const setSwitchings = createAction(
  '[Intersections] Set Switching',
  props<{ switchings: IntersectionSwitching[] }>()
);
export const setTrafficLights = createAction(
  '[Intersections] Set Traffic Lights',
  props<{ trafficLights: IntersectionTrafficLight[] }>()
);
export const switchManually = createAction(
  '[Intersections] Switch Manually',
  props<{ intersection: Intersection; switching: IntersectionSwitching }>()
);
export const switchAutomatically = createAction(
  '[Intersections] Switch Automatically',
  props<{ intersection: Intersection }>()
);
export const switchToStaticCam = createAction('[Intersections] Switch To Cam', props<{ staticCam: string }>());
