import BusIcon from '@mui/icons-material/DirectionsBus';
import TramIcon from '@mui/icons-material/Tram';
import TrainIcon from '@mui/icons-material/DirectionsRailway';
import SubwayIcon from '@mui/icons-material/DirectionsSubway';
import { blue, green, orange, red } from '@mui/material/colors';

export const getIcon = (trafficType: string) => {
  switch (trafficType) {
    default:
    case 'BUS':
      return <BusIcon />;
    case 'SUBWAY':
      return <SubwayIcon />;
    case 'TRAIN':
      return <TrainIcon />;
    case 'TRAM':
      return <TramIcon />;
  }
};

export const getColor = (trafficType: string) => {
  switch (trafficType) {
    default:
    case 'BUS':
      return orange[700];
    case 'SUBWAY':
      return red[500];
    case 'TRAIN':
      return green[500];
    case 'TRAM':
      return blue[500];
  }
};
