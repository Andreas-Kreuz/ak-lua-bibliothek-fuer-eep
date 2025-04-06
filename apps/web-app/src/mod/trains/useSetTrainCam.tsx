import { useSocket } from '../../io/SocketProvider';
import { CommandEvent } from '@ak/web-shared';
import useDebug from '../../io/useDebug';

const useSetTrainCam = () => {
  const socket = useSocket();
  const debug = useDebug();

  return (trainName: string, rollingStockName: string, camNr: number) => {
    if (debug) console.log('                 |📹 CAM SET --', 'for TRAIN', trainName, camNr);
    socket.emit(CommandEvent.ChangeCamToTrain, { trainName: trainName, rollingStockName: rollingStockName, id: camNr });
  };
};

export default useSetTrainCam;
