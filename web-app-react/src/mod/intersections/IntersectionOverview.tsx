import Button from '@mui/material/Button';
import Card from '@mui/material/Card';
import CardActionArea from '@mui/material/CardActionArea';
import CardActions from '@mui/material/CardActions';
import Typography from '@mui/material/Typography';
import AppCardBg from '../../ui/AppCardBg';
import useIntersections from './useIntersections';
import AppCardGrid from '../../ui/AppCardGrid';
import AppPageHeadline from '../../ui/AppPageHeadline';
import AppPage from '../../ui/AppPage';
import AppCardGridContainer from '../../ui/AppCardGridContainer';
import AppBackButton from '../../ui/AppBackButton';

function IntersectionOverview() {
  const intersections = useIntersections();

  return (
    <AppPage>
      <AppPageHeadline>
        <AppBackButton to="/" /> Kreuzungen
      </AppPageHeadline>
      <AppCardGridContainer>
        {intersections.map((i) => (
          <AppCardGrid key={i.id}>
            <AppCardBg
              title="Kreuzung"
              id={i.name}
              image="/assets/card-img-intersection.jpg"
              to={`/intersection/${i.id}`}
            />
          </AppCardGrid>
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
      </AppCardGridContainer>
    </AppPage>
  );
}

export default IntersectionOverview;
