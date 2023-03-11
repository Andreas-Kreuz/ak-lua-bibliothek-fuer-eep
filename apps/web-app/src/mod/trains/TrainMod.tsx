import { TrainProvider } from './TrainProvider';
import Trains from './Trains';

const TrainMod = () => {
  return (
    <TrainProvider>
      <Trains />
    </TrainProvider>
  );
};

export default TrainMod;
