import { lazy } from 'react';
const AppCardGrid = lazy(() => import('../ui/AppCardGrid'));
const AppCardGridContainer = lazy(() => import('../ui/AppCardGridContainer'));
const AppCardImg = lazy(() => import('../ui/AppCardImg'));
const AppPage = lazy(() => import('../ui/AppPage'));
import useNavState from '../nav/NavElements';
import VersionInfo from '../status/VersionInfo';

function MainMenu() {
  const navigation = useNavState();

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
      <VersionInfo />
    </AppPage>
  );
}

export default MainMenu;
