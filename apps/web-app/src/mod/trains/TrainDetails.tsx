import TrainCamList from './TrainCamList';
import { TrainListEntry } from '@ak/web-shared';
import BadgeIcon from '@mui/icons-material/Badge';
import DirectionsIcon from '@mui/icons-material/Directions';
import FingerprintIcon from '@mui/icons-material/Fingerprint';
import LabelIcon from '@mui/icons-material/Label';
import LocationOnIcon from '@mui/icons-material/LocationOn';
import RouteIcon from '@mui/icons-material/Route';
import Box from '@mui/material/Box';
import Chip from '@mui/material/Chip';
import Divider from '@mui/material/Divider';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import Stack from '@mui/material/Stack';
import TextField from '@mui/material/TextField';
import Typography from '@mui/material/Typography';
import { useState } from 'react';

export const getTrainChips = (t: TrainListEntry) => {
  const elements = getTrainElements(t).filter((el) => el.key !== 1 && el.on);
  return elements.map((el) => <Chip key={el.key} variant="outlined" label={el.primary} icon={<el.icon />} />);
};

export const getTrainElements = (t: TrainListEntry) => [
  { key: 1, on: t.id, icon: BadgeIcon, primary: t.id, description: 'Name des Fahrzeugs in EEP' },
  { key: 2, on: t.route, icon: DirectionsIcon, primary: t.route, description: 'Route aus EEP' },
  { key: 3, on: t.line, icon: RouteIcon, primary: t.line || '-', description: 'Linie' },
  {
    key: 4,
    on: t.destination,
    icon: LocationOnIcon,
    primary: (t.destination && t.destination + (t.via ? ' über ' + t.via : '')) || '-',
    description: 'Ziel der Linie',
  },
  { key: 'Zugname', on: t.name, icon: LabelIcon, primary: t.name || '-', description: 'Name des Zuges' },
];

const TrainDetails = (props: { train: TrainListEntry }) => {
  const [editMode, setEditMode] = useState(false);
  const t = props.train;
  const trainElements = getTrainElements(t);

  return (
    <>
      <TrainCamList trainName={t.id} rollingStockName={t.firstRollingStockName} />
      <Divider sx={{ my: 1 }} />
      <Typography variant="h6" component="span">
        Zugeinstellungen
      </Typography>
      <List
        dense
        sx={{
          '& .MuiListItemText-root': { display: 'flex', flexDirection: 'column-reverse' },
        }}
      >
        {trainElements
          .filter((e) => e.key !== 'Zugname')
          .map((el) => (
            <ListItem key={el.key}>
              <ListItemIcon>{<el.icon />}</ListItemIcon>
              <ListItemText primary={el.primary} secondary={el.description}></ListItemText>
            </ListItem>
          ))}
        <ListItem>
          <ListItemIcon>{<LabelIcon />}</ListItemIcon>
          <TextField
            disabled
            variant="outlined"
            id="outlined-required"
            label="Zugnummer"
            defaultValue={t.name || '-'}
          />
        </ListItem>
      </List>
      <Box
        component="form"
        sx={{
          '& .MuiTextField-root': { m: 1, width: '25ch' },
        }}
        noValidate
        autoComplete="off"
      ></Box>
      {/* <Typography variant="h6" component="span">
        Wageneinstellungen
      </Typography>
      <Divider sx={{ my: 1 }} />
      <Box
        component="form"
        sx={{
          '& .MuiTextField-root': { m: 1, width: '25ch' },
        }}
        noValidate
        autoComplete="off"
      >
        <TextField disabled id="outlined-required" label="Kfz-Kennzeichen" defaultValue="B AD 2002" />
        <TextField disabled id="outlined-required" label="Wagennummer" defaultValue="2002" />
      </Box> */}
    </>
  );
};

export default TrainDetails;
