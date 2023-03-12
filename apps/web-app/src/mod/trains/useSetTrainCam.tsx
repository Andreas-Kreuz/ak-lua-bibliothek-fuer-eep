import { useSocket } from '../../io/SocketProvider';
import { CommandEvent } from '@ak/web-shared';

const useSetTrainCam = () => {
  const socket = useSocket();
  return (trainName: string, rollingStockName: string, camNr: number) => {
    console.log('Change cam', trainName, camNr);
    socket.emit(CommandEvent.ChangeCamToTrain, { trainName: trainName, rollingStockName: rollingStockName, id: camNr });
  };
};

export default useSetTrainCam;
