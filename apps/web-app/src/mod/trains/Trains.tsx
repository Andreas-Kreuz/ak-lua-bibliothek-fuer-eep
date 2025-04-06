import { lazy } from 'react';
import setTrackType from './useSetTrackType';
import useTrackType from './useTrackType';
import useTrains from './useTrains';
import { TrackType } from '@ak/web-shared';
import Button from '@mui/material/Button';
import Card from '@mui/material/Card';
import CardActionArea from '@mui/material/CardActionArea';
import CardActions from '@mui/material/CardActions';
import Chip from '@mui/material/Chip';
import Grid from '@mui/material/Grid';
import Paper from '@mui/material/Paper';
import Typography from '@mui/material/Typography';
import { styled } from '@mui/material/styles';
import { useState } from 'react';
const AppCardGrid = lazy(() => import('../../ui/AppCardGrid'));
const AppCardGridContainer = lazy(() => import('../../ui/AppCardGridContainer'));
const AppPageHeadline = lazy(() => import('../../ui/AppPageHeadline'));
const AppPage = lazy(() => import('../../ui/AppPage'));
const TrainListEntryCard = lazy(() => import('./TrainListEntryCard'));

interface ChipData {
  key: TrackType;
  label: string;
}

const ListItem = styled('li')(({ theme }) => ({
  margin: theme.spacing(0.5),
}));

const Trains = () => {
  const trains = useTrains();
  const trackType = useTrackType();
  const setType = setTrackType();

  const [chipData, setChipData] = useState<readonly ChipData[]>([
    { key: TrackType.Rail, label: 'Gleise' },
    { key: TrackType.Tram, label: 'Straßenbahn' },
    { key: TrackType.Road, label: 'Straße' },
    { key: TrackType.Auxiliary, label: 'Sonstige Splines' },
    { key: TrackType.Control, label: 'Steuerstrecken' },
  ]);

  return (
    <AppPage>
      <AppPageHeadline>Gleissystem</AppPageHeadline>
      <Paper
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
              label={data.label}
              variant="filled"
              color={trackType === data.key ? 'primary' : 'default'}
              onClick={() => setType(data.key)}
            />
          </ListItem>
        ))}
      </Paper>
      <AppCardGridContainer>
        <AppPageHeadline gutterTop>
          Fahrzeuge {chipData.filter((e, i) => e.key == trackType).map((e) => e.label)}
        </AppPageHeadline>
        {trains.length === 0 ? (
          <Grid size={{ xs: 12 }}>
            <>
              <Typography variant="body2">
                Es wurden keine Fahrzeuge im Gleissystem{' '}
                {chipData.filter((e, i) => e.key == trackType).map((e) => e.label)} gefunden. Wähle ein anderes
                Gleissystem oder füge Fahrzeuge in EEP hinzu.
              </Typography>
            </>
          </Grid>
        ) : (
          <>
            {trains.map((t) => (
              <Grid size={{ xs: 12 }} key={t.id}>
                <TrainListEntryCard train={t} />
              </Grid>
            ))}
          </>
        )}
      </AppCardGridContainer>

      <AppPageHeadline gutterTop>Hilfe</AppPageHeadline>
      <AppCardGridContainer>
        <Grid size={{ xs: 12 }}>
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
        </Grid>
      </AppCardGridContainer>
    </AppPage>
  );
};

export default Trains;
