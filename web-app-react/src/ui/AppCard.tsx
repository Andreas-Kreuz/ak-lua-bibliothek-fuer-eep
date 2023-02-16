import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import CardActionArea from '@mui/material/CardActionArea';
import CardMedia from '@mui/material/CardMedia';
import Chip from '@mui/material/Chip';
import Stack from '@mui/material/Stack';
import { useTheme } from '@mui/material/styles';
import Typography from '@mui/material/Typography';
import useMediaQuery from '@mui/material/useMediaQuery';
import { Link as RouterLink } from 'react-router-dom';

function AppCard(props: {
  title: string;
  subtitle?: string;
  id?: string;
  to?: string;
  image: string;
  small?: boolean;
}) {
  const theme = useTheme();
  const small = true || props.small || useMediaQuery(theme.breakpoints.up('sm'));

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
      {small && (
        <CardActionArea
          component={RouterLink}
          to={props.to || ''}
          sx={{
            p: 2,
            background:
              'radial-gradient(circle at right, ' +
              'rgba(255,255,255,0) 0%, rgba(255,255,255,0) 10%, rgba(255,255,255,1) 50%), ' +
              'url(' +
              '/assets/' +
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
      )}

      {!small && (
        <>
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
              <Box sx={{ p: 2 }}>{contents}</Box>
            </Stack>
          </CardActionArea>
        </>
      )}
    </Card>
  );
}

export default AppCard;
