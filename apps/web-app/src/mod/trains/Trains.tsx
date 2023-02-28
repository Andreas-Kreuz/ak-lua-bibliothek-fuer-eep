import AppCardBg from '../../ui/AppCardBg';
import AppCardGrid from '../../ui/AppCardGrid';
import AppCardGridContainer from '../../ui/AppCardGridContainer';
import AppPageHeadline from '../../ui/AppHeadline';
import AppPage from '../../ui/AppPage';
import useTrains from './useTrains';
import Button from '@mui/material/Button';
import Card from '@mui/material/Card';
import CardActionArea from '@mui/material/CardActionArea';
import CardActions from '@mui/material/CardActions';
import Chip from '@mui/material/Chip';
import Divider from '@mui/material/Divider';
import Typography from '@mui/material/Typography';
import Grid from '@mui/material/Unstable_Grid2/Grid2';

const Trains = () => {
  const trains = useTrains();

  if (trains.length > 0) {
    console.log(trains[0]);
  }

  const getImageName = (trackType: string): string => {
    switch (trackType) {
      case 'road':
        return '/assets/card-img-trains-road.jpg';
      case 'tram':
        return '/assets/card-img-trains-tram.jpg';
      case 'train':
      default:
        return '/assets/card-img-trains-rail.jpg';
    }
  };

  return (
    <AppPage>
      <AppPageHeadline>Fahrzeuge</AppPageHeadline>
      <AppCardGridContainer>
        {trains.map((t) => (
          <Grid xs={12} key={t.id}>
            <AppCardBg title={`Fahrzeug`} id={t.id} image={getImageName(t.trackType)} to={`/train/${t.id}`}>
              <Chip variant="filled" label={t.destination} />
              {/* <Chip variant="filled" label={t.direction} /> */}
              <Chip variant="filled" label={t.id} />
              {/* <Chip variant="filled" label={t.length} /> */}
              <Chip variant="filled" label={t.line} />
              <Chip variant="filled" label={t.name} />
              <Chip variant="filled" label={t.route} />
              {/* <Chip variant="filled" label={t.speed} /> */}
              {/* <Chip variant="filled" label={t.trackSystem} /> */}
              <Chip variant="filled" label={t.trackType} />
              <Chip variant="filled" label={t.trainType} />
              <Divider sx={{ my: 1 }} />
              {/* <Stack>
                {t.rollingStock?.map((r) => {
                  return <Chip variant="filled" label={r.id} />;
                })}
              </Stack> */}
            </AppCardBg>
          </Grid>
        ))}
      </AppCardGridContainer>

      <AppPageHeadline gutterTop>Hilfe</AppPageHeadline>
      <AppCardGridContainer>
        <AppCardGrid>
          <Card>
            <CardActionArea sx={{ p: 2 }} disabled>
              <Typography variant="h5" gutterBottom>
                Hilfe
              </Typography>
              <Typography variant="body2">Erfahre, wie Du Fahrzeuge verwalten kannst.</Typography>
            </CardActionArea>
            <CardActions>
              <Button
                href="https://andreas-kreuz.github.io/ak-lua-bibliothek-fuer-eep/docs/anleitungen/"
                target="_blank"
                rel="noopener noreferrer"
              >
                Anleitung
              </Button>
            </CardActions>
          </Card>
        </AppCardGrid>
      </AppCardGridContainer>
    </AppPage>
  );
};

export default Trains;
