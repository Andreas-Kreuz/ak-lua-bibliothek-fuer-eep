import Button from '@mui/material/Button';
import Card from '@mui/material/Card';
import CardActionArea from '@mui/material/CardActionArea';
import CardActions from '@mui/material/CardActions';
import Grid from '@mui/material/Unstable_Grid2';
import Typography from '@mui/material/Typography';
import AppCardBg from '../../ui/AppCardBg';
import useIntersections from './useIntersections';
import AppCardGrid from '../../ui/AppCardGrid';

function IntersectionOverview() {
  const intersections = useIntersections();

  return (
    <>
      <Grid container spacing={2} sx={{ m: 2 }}>
        {intersections.map((i) => (
          <AppCardGrid key={i.id}>
            <AppCardBg title="Kreuzung" id={i.name} image="/assets/card-img-intersection.jpg" />
          </AppCardGrid>
        ))}
      </Grid>
      <Grid container spacing={2} sx={{ mb: 2, mx: 2 }}>
        <AppCardGrid>
          <Card>
            <CardActionArea sx={{ p: 2 }} disabled>
              <Typography variant="h5" gutterBottom>
                Hilfe
              </Typography>
              <Typography variant="body2">Erfahre wie Du Kreuzungen mit der Lua-Bibliothek einrichtest</Typography>
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
      </Grid>
    </>
  );
}

export default IntersectionOverview;
