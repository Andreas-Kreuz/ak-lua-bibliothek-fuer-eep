import Button from '@mui/material/Button';
import Card from '@mui/material/Card';
import CardActionArea from '@mui/material/CardActionArea';
import CardActions from '@mui/material/CardActions';
import Grid from '@mui/material/Unstable_Grid2';
import Typography from '@mui/material/Typography';
import AppCard from '../../ui/AppCard';
import useIntersections from './useIntersections';

function IntersectionOverview() {
  const intersections = useIntersections();

  return (
    <>
      <Grid container spacing={2} sx={{ p: 2 }}>
        {intersections.map((i) => (
          <Grid xs={12} sm={6} lg={3} key={i.id}>
            <AppCard title="Kreuzung" id={i.name} image="card-img-intersection.jpg" />
          </Grid>
        ))}
      </Grid>
      <Grid container spacing={2} sx={{ pb: 2, px: 2 }}>
        <Grid xs={12} sm={6}>
          <Card>
            <CardActionArea sx={{ p: 2 }}>
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
        </Grid>
      </Grid>
    </>
  );
}

export default IntersectionOverview;
