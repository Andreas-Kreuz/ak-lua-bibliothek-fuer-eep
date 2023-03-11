import useSetTrainCam from './setTrainCam';
import CamIcon from '@mui/icons-material/Videocam';
import Box from '@mui/material/Box';
import Chip from '@mui/material/Chip';
import { styled } from '@mui/material/styles';
import { useState } from 'react';

interface ChipData {
  key: number;
  label: string;
}

const ListItem = styled('li')(({ theme }) => ({
  margin: theme.spacing(0.5),
}));

const TrainCamList = (props: { trainName: string }) => {
  const setTrainCam = useSetTrainCam();
  const [chipData, setChipData] = useState<readonly ChipData[]>([
    { key: 9, label: 'Fahrtrichtung oben' },
    // { key: -1, label: 'K2' },
    { key: 3, label: 'Vorne links' },
    { key: 4, label: 'Vorne rechts' },
    { key: 10, label: 'Cockpit' },
  ]);

  return (
    <Box
      sx={{
        display: 'flex',
        justifyContent: 'center',
        flexWrap: 'wrap',
        listStyle: 'none',
        p: 0.5,
        m: 0,
      }}
      component="ul"
    >
      {chipData.map((data) => (
        <ListItem key={data.key}>
          <Chip
            size="small"
            icon={<CamIcon />}
            label={data.label}
            variant="filled"
            onClick={() => setTrainCam(props.trainName, data.key)}
          />
        </ListItem>
      ))}
    </Box>
  );
};

export default TrainCamList;
