import AppCardGrid from '../../ui/AppCardGrid';
import AppCardGridContainer from '../../ui/AppCardGridContainer';
import AppPageHeadline from '../../ui/AppHeadline';
import AppPage from '../../ui/AppPage';
import TrainListEntryCard from './TrainListEntryCard';
import setTrackType from './useSetTrackType';
import useTrackType from './useTrackType';
import useTrains from './useTrains';
import { TrackType } from '@ak/web-shared';
import Button from '@mui/material/Button';
import Card from '@mui/material/Card';
import CardActionArea from '@mui/material/CardActionArea';
import CardActions from '@mui/material/CardActions';
import Chip from '@mui/material/Chip';
import Paper from '@mui/material/Paper';
import Typography from '@mui/material/Typography';
import Grid from '@mui/material/Unstable_Grid2/Grid2';
import { styled } from '@mui/material/styles';
import { useState } from 'react';

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
      <AppPageHeadline gutterBottom>Gleissystem</AppPageHeadline>
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
      <AppPageHeadline gutterTop gutterBottom>
        Fahrzeuge
      </AppPageHeadline>
      <AppCardGridContainer>
        {trains.map((t) => (
          <Grid xs={12} key={t.id}>
            <TrainListEntryCard train={t} />
          </Grid>
        ))}
      </AppCardGridContainer>

      <AppPageHeadline gutterTop gutterBottom>
        Hilfe
      </AppPageHeadline>
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
