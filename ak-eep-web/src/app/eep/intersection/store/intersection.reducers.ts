import { createFeatureSelector, createSelector, createReducer, Action, on } from '@ngrx/store';
import * as IntersectionActions from './intersection.actions';
import { Intersection } from '../models/intersection.model';
import { IntersectionLane } from '../models/intersection-lane.model';
import { IntersectionSwitching } from '../models/intersection-switching.model';
import { IntersectionTrafficLight } from '../models/intersection-traffic-light.model';

export interface State {
  intersections: Intersection[];
  lanes: IntersectionLane[];
  switchings: IntersectionSwitching[];
  trafficLights: IntersectionTrafficLight[];
}

const initialState: State = {
  intersections: [],
  lanes: [],
  switchings: [],
  trafficLights: [],
};


const intersectionsReducer = createReducer(
  initialState,
  on(IntersectionActions.setIntersections, (state: State, { intersections }) => ({ ...state, intersections: [...intersections] })),
  on(IntersectionActions.setLanes, (state: State, { lanes }) => ({ ...state, lanes: [...lanes] })),
  on(IntersectionActions.setSwitchings, (state: State, { switchings }) => ({ ...state, switchings: [...switchings] })),
  on(IntersectionActions.setTrafficLights, (state: State, { trafficLights }) => ({ ...state, trafficLights: [...trafficLights] }))
);

export function reducer(state: State | undefined, action: Action) {
  return intersectionsReducer(state, action);
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
  (state: State) => state.lanes
);

export const laneByIntersectionId$ = (intersectionId) => createSelector(
  intersectionLanes$,
  intersections => intersections
    .filter((i: IntersectionLane) => intersectionId === i.intersectionId)
);


export const intersectionSwitching$ = createSelector(
  intersectionsState$,
  (state: State) => state.switchings
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
  (state: State) => state.trafficLights
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

