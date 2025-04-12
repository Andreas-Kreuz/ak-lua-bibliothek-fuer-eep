import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import CardActionArea from '@mui/material/CardActionArea';
import CardMedia from '@mui/material/CardMedia';
import Chip from '@mui/material/Chip';
import Stack from '@mui/material/Stack';
import Typography from '@mui/material/Typography';
import { Link as RouterLink } from 'react-router-dom';

export interface AppCardImgProps {
  title: string;
  subtitle?: string;
  id?: string;
  image?: string;
  to?: string;
  small?: boolean;
}

function AppCardImg(props: AppCardImgProps) {
  const contents = (
    <>
      <Typography variant="h5">{props.title}</Typography>
      {props.subtitle && (
        <Typography variant="body1" sx={{ color: 'text.secondary' }}>
          {props.subtitle}
        </Typography>
      )}
      {props.id && <Chip label={props.id} />}
    </>
  );

  const stack = (
    <Stack sx={{ flexDirection: { xs: 'row', sm: 'column' } }}>
      {props.image && (
        <CardMedia component="img" image={props.image} title={props.title} sx={{ width: { xs: '25%', sm: 1 } }} />
      )}
      <Box sx={{ p: 2 }}>{contents}</Box>
    </Stack>
  );

  return (
    <Card sx={{ flexGrow: 1, display: 'flex', alignItems: 'stretch', alignContent: 'stretch' }}>
      {(props.to && (
        <CardActionArea
          sx={{ display: 'flex', alignItems: 'stretch', alignContent: 'stretch' }}
          component={RouterLink}
          to={props.to}
        >
          {stack}
        </CardActionArea>
      )) || <Box sx={{ display: 'flex', alignItems: 'stretch', alignContent: 'stretch' }}>{stack}</Box>}
    </Card>
  );
}

export default AppCardImg;
