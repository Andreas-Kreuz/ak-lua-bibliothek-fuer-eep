import AppCardBg from '../../ui/AppCardBg';
import AppCardGrid from '../../ui/AppCardGrid';
import AppCardGridContainer from '../../ui/AppCardGridContainer';
import AppPage from '../../ui/AppPage';
import AppPageHeadline from '../../ui/AppPageHeadline';
import ModuleSettings from '../../ui/ModuleSettings';
import useIntersectionSettings from './useIntersectionSettings';
import useIntersections from './useIntersections';
import Button from '@mui/material/Button';
import Card from '@mui/material/Card';
import CardActionArea from '@mui/material/CardActionArea';
import CardActions from '@mui/material/CardActions';
import Typography from '@mui/material/Typography';

function IntersectionOverview() {
  const intersections = useIntersections();
  const settings = useIntersectionSettings();

  return (
    <AppPage>
      <AppPageHeadline>Kreuzungen</AppPageHeadline>
      <AppCardGridContainer>
        {intersections.map((i) => (
          <AppCardGrid key={i.id}>
            <AppCardBg
              title={`Kreuzung ${i.id}`}
              id={i.name}
              image="/assets/card-img-intersection.jpg"
              to={`/intersection/${i.id}`}
            />
          </AppCardGrid>
        ))}
      </AppCardGridContainer>

      <AppPageHeadline gutterTop>Einstellungen und Hilfe</AppPageHeadline>
      <AppCardGridContainer>
        {settings && (
          <AppCardGrid>
            <Card sx={{ p: 2 }}>
              <Typography variant="h5" gutterBottom>
                Einstellungen
              </Typography>
              <ModuleSettings settings={settings} />
            </Card>
          </AppCardGrid>
        )}
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
