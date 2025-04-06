import { lazy } from 'react';
import useNavState from '../nav/NavElements';
import VersionInfo from '../status/VersionInfo';
import { useNavigate } from 'react-router-dom';
import BarChartIcon from '@mui/icons-material/BarChart';
import Grid from '@mui/material/Grid';
import Button from '@mui/material/Button';
const AppCardGrid = lazy(() => import('../ui/AppCardGrid'));
const AppCardGridContainer = lazy(() => import('../ui/AppCardGridContainer'));
const AppCardImg = lazy(() => import('../ui/AppCardImg'));
const AppPage = lazy(() => import('../ui/AppPage'));

function MainMenu() {
  const navigation = useNavState();
  const navigate = useNavigate();

  const trafficNav = navigation.filter((nav) => nav.name === 'Verkehr').flatMap((nav) => nav.values);
  const dataNav = navigation.filter((nav) => nav.name === 'Daten').flatMap((nav) => nav.values);

  return (
    <AppPage>
      <AppCardGridContainer>
        {trafficNav.map((card) => (
          <AppCardGrid key={card.title}>
            <AppCardImg title={card.title} subtitle={card.subtitle} image={'/assets/' + card.image} to={card.link} />
          </AppCardGrid>
        ))}
      </AppCardGridContainer>
      <Grid container style={{ alignItems: 'center' }} justifyContent={'space-between'}>
        <VersionInfo />
        <Button variant="contained" startIcon={<BarChartIcon />} onClick={() => navigate('statistics')}>
          Statistik
        </Button>
      </Grid>
    </AppPage>
  );
}

export default MainMenu;
