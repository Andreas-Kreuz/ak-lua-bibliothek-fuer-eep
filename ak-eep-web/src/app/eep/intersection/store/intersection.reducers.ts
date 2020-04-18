import { createFeatureSelector, createSelector } from '@ngrx/store';

import * as fromIntersection from './intersection.actions';
import { Intersection } from '../models/intersection.model';
import { IntersectionLane } from '../models/intersection-lane.model';
import { IntersectionSwitching } from '../models/intersection-switching.model';
import { IntersectionTrafficLight } from '../models/intersection-traffic-light.model';

export interface State {
  intersections: Intersection[];
  intersectionLanes: IntersectionLane[];
  intersectionSwitching: IntersectionSwitching[];
  intersectionTrafficLights: IntersectionTrafficLight[];
}

const initialState: State = {
  intersections: [],
  intersectionLanes: [],
  intersectionSwitching: [],
  intersectionTrafficLights: [],
};

export function reducer(state: State = initialState, action: fromIntersection.IntersectionActions) {
  switch (action.type) {
    case fromIntersection.SET_INTERSECTIONS:
      return {
        ...state,
        intersections: [...action.payload],
      };
    case fromIntersection.SET_INTERSECTION_SWITCHING:
      return {
        ...state,
        intersectionSwitching: [...action.payload],
      };
    case fromIntersection.SET_INTERSECTION_LANES:
      return {
        ...state,
        intersectionLanes: [...action.payload],
      };
    default:
      return state;
  }
}

export const intersectionsState$ = createFeatureSelector('intersection');

export const intersections$ = createSelector(
  intersectionsState$,
  (state: State) => state.intersections
);

export const intersectionsCount$ = createSelector(
  intersectionsState$,
  (state: State) => state.intersections.length
);

export const intersectionLanes$ = createSelector(
  intersectionsState$,
  (state: State) => state.intersectionLanes
);

export const laneByIntersectionId$ = (intersectionId) => createSelector(
  intersectionLanes$,
  intersections => intersections
    .filter((i: IntersectionLane) => intersectionId === i.intersectionId)
);


export const intersectionSwitching$ = createSelector(
  intersectionsState$,
  (state: State) => state.intersectionSwitching
);

export const switchingNamesByIntersection$ = (intersectionId: Intersection) => createSelector(
  intersectionSwitching$,
  switching => switching
    .filter((is: IntersectionSwitching) => intersectionId.name === is.intersectionId)
    .sort((a, b) => a.name.localeCompare(b.name))
);

export const intersectionById$ = (intersectionId) => createSelector(
  intersections$,
  intersections => intersections
    .find((i: Intersection) => intersectionId === i.id)
);

export const intersectionTrafficLights$ = createSelector(
  intersectionsState$,
  (state: State) => state.intersectionTrafficLights
);

export const signalTypes$ = createSelector(
  intersectionTrafficLights$,
  (trafficLights: IntersectionTrafficLight[]) => {
    const signalTypeMap = new Map<number, string>();
    for (const trafficLight of trafficLights) {
      signalTypeMap.set(trafficLight.id, trafficLight.modelId);
    }
    return signalTypeMap;
  }
);

