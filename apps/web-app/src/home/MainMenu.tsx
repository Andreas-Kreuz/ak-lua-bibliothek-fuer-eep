import useNavState from '../nav/NavElements';
import VersionInfo from '../status/VersionInfo';
import AppCardGrid from '../ui/AppCardGrid';
import AppCardGridContainer from '../ui/AppCardGridContainer';
import AppCardImg from '../ui/AppCardImg';
import AppPage from '../ui/AppPage';

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
