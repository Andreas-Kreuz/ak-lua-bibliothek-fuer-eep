import { useTrain } from './TrainProvider';
import { TrackType } from '@ak/web-shared';

function useTrackType(): TrackType {
  const trainStore = useTrain();
  return trainStore?.trackType || TrackType.Auxiliary;
}

export default useTrackType;
