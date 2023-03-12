import useRollingStock from './useRollingStock';
import useSetRollingStockCam from './useSetRollingStockCam';
import useSetTrainCam from './useSetTrainCam';
import CamIcon from '@mui/icons-material/Videocam';
import Box from '@mui/material/Box';
import Chip from '@mui/material/Chip';
import Typography from '@mui/material/Typography';
import { styled } from '@mui/material/styles';
import { useState } from 'react';

interface ChipData {
  key: number;
  label: string;
}

const ListItem = styled('li')(({ theme }) => ({
  margin: theme.spacing(0.5),
}));

const TrainCamList = (props: { trainName: string; rollingStockName: string }) => {
  const rollingStock = useRollingStock(props.rollingStockName);
  const setRollingStockCam = useSetRollingStockCam();
  const setTrainCam = useSetTrainCam();
  const [chipData, setChipData] = useState<readonly ChipData[]>([
    { key: 3, label: 'Links oben' },
    { key: 4, label: 'Rechts oben' },
    { key: 8, label: 'Führerstand' },
    { key: -1, label: 'Front' },
    { key: -2, label: 'Front 2' },
    { key: 10, label: 'Kabine' },
  ]);

  const changeCam = (key: number) => {
    switch (key) {
      case -1:
      case -2: {
        console.log(props.rollingStockName);
        console.log(rollingStock);
        setRollingStockCam(rollingStock, key);
        setTrainCam(props.trainName, props.rollingStockName, 9);
        break;
      }
      default: {
        setTrainCam(props.trainName, props.rollingStockName, key);
      }
    }
  };

  return (
    <Box
      sx={{
        width: 1,
        display: 'flex',
        flexWrap: 'wrap',
        listStyle: 'none',
        alignContent: 'center',
        p: 0,
        m: 0,
      }}
      component="ul"
    >
      <ListItem key="caption">
        <Typography variant="caption" color="GrayText">
          Kameras
        </Typography>
      </ListItem>
      {chipData.map((data) => (
        <ListItem key={data.key}>
          <Chip
            size="small"
            icon={<CamIcon />}
            label={data.label}
            variant="filled"
            onClick={() => changeCam(data.key)}
          />
        </ListItem>
      ))}
    </Box>
  );
};

export default TrainCamList;
