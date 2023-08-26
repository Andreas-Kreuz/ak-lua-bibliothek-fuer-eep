import LineSegment from './model/LineSegment';
import PlaceIcon from '@mui/icons-material/Place';
import Box from '@mui/material/Box';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import Typography from '@mui/material/Typography';

const PublicTransportLineSegment = (props: { segment: LineSegment }) => {
  const segment = props.segment;

  return (
    <Box>
      <Typography sx={{ m: 0 }} variant="h6" component="div">
        Richtung {segment.destination}
      </Typography>
      <List dense>
        {segment.stations.map((s, index) => (
          <>
            <ListItem
              sx={{
                '& .MuiListItemText-secondary': {
                  fontSize: '0.85rem',
                },
                '&:first-child .MuiListItemText-primary': {
                  fontWeight: 'bold',
                },
                '&:last-child .MuiListItemText-primary': {
                  fontWeight: 'bold',
                },
                '& .MuiSvgIcon-root': {
                  color: '#999999',
                },
                '&:first-child .MuiSvgIcon-root': {
                  color: '#666666',
                },
                '&:last-child .MuiSvgIcon-root': {
                  color: '#666666',
                },
              }}
            >
              <ListItemIcon>
                <PlaceIcon />
              </ListItemIcon>
              <ListItemText primary={s.station.name} secondary={(index === 0 ? '' : '+ ') + s.timeToStation + ' min'} />
            </ListItem>
          </>
        ))}
      </List>
    </Box>
  );
};

export default PublicTransportLineSegment;
