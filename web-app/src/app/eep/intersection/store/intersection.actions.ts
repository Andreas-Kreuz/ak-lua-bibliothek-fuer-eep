import { Action, createAction, props } from '@ngrx/store';


import { Intersection } from '../models/intersection.model';
import { IntersectionLane } from '../models/intersection-lane.model';
import { IntersectionSwitching } from '../models/intersection-switching.model';
import { IntersectionTrafficLight } from '../models/intersection-traffic-light.model';

export const setIntersections = createAction('[Intersections] Set', props<{ intersections: Intersection[] }>());
export const setLanes = createAction('[Intersections] Set Lanes', props<{ lanes: IntersectionLane[] }>());
export const setSwitchings =
  createAction('[Intersections] Set Switching', props<{ switchings: IntersectionSwitching[] }>());
export const setTrafficLights =
  createAction('[Intersections] Set Traffic Lights', props<{ trafficLights: IntersectionTrafficLight[] }>());
export const switchManually =
  createAction('[Intersections] Switch Manually', props<{ intersection: Intersection, switching: IntersectionSwitching }>());
export const switchAutomatically = createAction('[Intersections] Switch Automatically', props<{ intersection: Intersection }>());
export const switchToCam = createAction('[Intersections] Switch To Cam', props<{ staticCam: string }>());
