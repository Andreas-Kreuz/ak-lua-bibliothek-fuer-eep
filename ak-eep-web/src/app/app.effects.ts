import { CoreEffects } from './core/store/core.effects';
import { DataTypesEffects } from './core/datatypes/store/data-types.effects';
import { EepDataEffects } from './eep/data/store/eep-data.effects';
import { GenericDataEffects } from './eep/generic-data/store/generic-data.effects';
import { IntersectionEffects } from './eep/intersection/store/intersection.effects';
import { SignalEffects } from './eep/signals/store/signal.effects';
import { TrainEffects } from './eep/trains/store/train.effects';

export const effects = [
  CoreEffects,
  DataTypesEffects,
  EepDataEffects,
  GenericDataEffects,
  IntersectionEffects,
  SignalEffects,
  TrainEffects,
];
