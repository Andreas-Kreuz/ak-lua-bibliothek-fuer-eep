import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import CardActionArea from '@mui/material/CardActionArea';
import Chip from '@mui/material/Chip';
import Stack from '@mui/material/Stack';
import Typography from '@mui/material/Typography';
import { Link as RouterLink } from 'react-router-dom';

function AppCardBg(props: {
  title: string;
  subtitle?: string;
  id?: string;
  to?: string;
  image: string;
  small?: boolean;
}) {
  const contents = (
    <Box>
      <Typography variant="h5" gutterBottom>
        {props.title}
      </Typography>
      {props.subtitle && (
        <Typography variant="h5" gutterBottom>
          {props.subtitle}
        </Typography>
      )}
      {props.id && <Chip label={props.id} />}
    </Box>
  );

  return (
    <Card>
      <CardActionArea
        component={RouterLink}
        to={props.to || ''}
        sx={{
          p: 2,
          background:
            'radial-gradient(circle at right, ' +
            'rgba(255,255,255,0) 0px, rgba(255,255,255,0) 100px, rgba(255,255,255,1) 200px), ' +
            'url(' +
            props.image +
            ')',
          backgroundSize: 'auto 150%',
          backgroundPositionX: '100%',
          backgroundPositionY: '60%',
          backgroundRepeat: 'no-repeat',
        }}
      >
        <Stack sx={{ flexDirection: { xs: 'row' }, alignItems: 'center' }}>{contents}</Stack>
      </CardActionArea>
    </Card>
  );
}

export default AppCardBg;
