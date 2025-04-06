import { useSocket } from '../../io/SocketProvider';
import { CommandEvent, RollingStock } from '@ak/web-shared';
import useDebug from '../../io/useDebug';

const useSetRollingStockCam = () => {
  const socket = useSocket();
  const debug = useDebug();

  return (rollingStock: RollingStock, key: number) => {
    if (debug) console.log('                 |📹 CAM SET --', 'for ROLLING STOCK', rollingStock, key);
    if (!rollingStock) {
      return;
    }
    switch (key) {
      case -1: {
        const posX = rollingStock.length / 2 + 12;
        socket.emit(CommandEvent.ChangeCamToRollingStock, {
          rollingStock: rollingStock.id,
          posX: posX,
          posY: 1.5,
          posZ: 5,
          redH: 350,
          redV: 80,
          activate: 1,
        });
        return;
      }
      case -2: {
        const posX = rollingStock.length / 2 + 6;
        socket.emit(CommandEvent.ChangeCamToRollingStock, {
          rollingStock: rollingStock.id,
          posX: posX,
          posY: 4,
          posZ: 3.2,
          redH: 340,
          redV: 80,
          activate: 1,
        });
        return;
      }
    }
  };
};

export default useSetRollingStockCam;
