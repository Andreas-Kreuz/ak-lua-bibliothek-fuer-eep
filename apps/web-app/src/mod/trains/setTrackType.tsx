import { useTrain, useTrainDispatch } from './TrainProvider';
import { TrackType } from '@ak/web-shared';

function setTrackType(): (trackType: TrackType) => void {
  const trainDispatch = useTrainDispatch();

  return (trackType: TrackType) => {
    trainDispatch && trainDispatch({ type: 'set track type', trackType: trackType });
  };
}

export default setTrackType;
