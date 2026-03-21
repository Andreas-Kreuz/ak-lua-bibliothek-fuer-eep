import LineSegment from './model/LineSegment';
import PlaceIcon from '@mui/icons-material/Place';
import TripOriginIcon from '@mui/icons-material/TripOrigin';
import RadioButtonUncheckedIcon from '@mui/icons-material/RadioButtonUnchecked';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import Typography from '@mui/material/Typography';
import { ReactNode } from 'react';

export interface TransitLineSegmentProps {
  segment: LineSegment;
}

const TransitLineSegment = (props: TransitLineSegmentProps) => {
  const segment = props.segment;
  const MyListItem = (props: { children: ReactNode }) => (
    <ListItem
      sx={{
        '& .MuiListItemText-secondary': {
          fontSize: '0.85rem',
        },
        '.MuiListItemText-primary': {
          fontWeight: '500',
        },
        '&:first-child .MuiListItemText-primary': {
          fontWeight: '600',
        },
        '&:last-child .MuiListItemText-primary': {
          fontWeight: '600',
        },
        '& .MuiSvgIcon-root': {
          color: '#666666',
        },
        '&:first-child .MuiSvgIcon-root': {
          // color: '#666666',
        },
        '&:last-child .MuiSvgIcon-root': {
          // color: '#666666',
        },
      }}
    >
      {props.children}
    </ListItem>
  );

  return (
    <>
      <Typography variant="h5" pt={2} px={2}>
        {'Richtung: ' + segment.destination}
      </Typography>
      <List dense>
        {segment.stations.map((s, index) => (
          <>
            <MyListItem>
              <ListItemText primary={s.station.name} secondary={(index === 0 ? '' : '+ ') + s.timeToStation + ' min'} />
              <ListItemIcon
                sx={{
                  minWidth: 0,
                  textAlign: 'center',
                }}
              >
                {(index === 0 && <TripOriginIcon />) || (index === segment.stations.length - 1 && <PlaceIcon />) || (
                  <RadioButtonUncheckedIcon />
                )}
              </ListItemIcon>
            </MyListItem>
          </>
        ))}
      </List>
    </>
  );
};

export default TransitLineSegment;
