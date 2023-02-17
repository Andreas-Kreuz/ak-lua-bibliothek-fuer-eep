import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import CardActionArea from '@mui/material/CardActionArea';
import CardMedia from '@mui/material/CardMedia';
import Chip from '@mui/material/Chip';
import Stack from '@mui/material/Stack';
import Typography from '@mui/material/Typography';
import { Link as RouterLink } from 'react-router-dom';

function AppCardImg(props: {
  title: string;
  subtitle?: string;
  id?: string;
  to?: string;
  image: string;
  small?: boolean;
}) {
  const contents = (
    <Box>
      <Typography variant="h5">{props.title}</Typography>
      {props.subtitle && (
        <Typography variant="body1" sx={{ color: 'text.secondary' }}>
          {props.subtitle}
        </Typography>
      )}
      {props.id && <Chip label={props.id} />}
    </Box>
  );

  return (
    <Card>
      <CardActionArea component={RouterLink} to={props.to || ''}>
        <Stack sx={{ flexDirection: { xs: 'row', sm: 'column' } }}>
          {props.image && (
            <CardMedia component="img" image={props.image} title={props.title} sx={{ width: { xs: '25%', sm: 1 } }} />
          )}
          <Box sx={{ p: 2 }}>{contents}</Box>
        </Stack>
      </CardActionArea>
    </Card>
  );
}

export default AppCardImg;
