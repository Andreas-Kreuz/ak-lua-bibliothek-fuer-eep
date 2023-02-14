import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import CardActionArea from '@mui/material/CardActionArea';
import CardMedia from '@mui/material/CardMedia';
import Chip from '@mui/material/Chip';
import Stack from '@mui/material/Stack';
import Typography from '@mui/material/Typography';
import { Link as RouterLink } from 'react-router-dom';

function AppCard(props: { title: string; subtitle?: string; id?: string; to?: string; image: string }) {
  return (
    <Card elevation={3} sx={{ borderRadius: 3 }}>
      <CardActionArea component={RouterLink} to={props.to || ''}>
        <Stack sx={{ flexDirection: { xs: 'row', sm: 'column' } }}>
          {props.image && (
            <CardMedia
              component="img"
              image={'/assets/' + props.image}
              title={props.title}
              sx={{ width: { xs: '25%', sm: 1 }, borderRadius: 2, height: { sm: '10em' } }}
            />
          )}
          <Box sx={{ p: 2 }}>
            <Typography variant="h4" gutterBottom>
              {props.title}
            </Typography>
            {props.subtitle && <Typography variant="h5">{props.subtitle}</Typography>}
            {props.id && <Chip label={props.id} variant="outlined" />}
          </Box>
        </Stack>
      </CardActionArea>
    </Card>
  );
}

export default AppCard;
