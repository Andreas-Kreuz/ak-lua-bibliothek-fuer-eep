import useNavState from '../nav/NavElements';
import VersionInfo from '../status/VersionInfo';
import AppCardGrid from '../ui/AppCardGrid';
import AppCardGridContainer from '../ui/AppCardGridContainer';
import AppCardImg from '../ui/AppCardImg';

function MainMenu() {
  const navigation = useNavState();

  const trafficNav = navigation.filter((nav) => nav.name === 'Verkehr').flatMap((nav) => nav.values);
  const dataNav = navigation.filter((nav) => nav.name === 'Daten').flatMap((nav) => nav.values);
  console.log(trafficNav[0].image);

  return (
    <>
      <AppCardGridContainer>
        {trafficNav.map((card) => (
          <AppCardGrid key={card.title}>
            <AppCardImg title={card.title} subtitle={card.subtitle} image={'/assets/' + card.image} to={card.link} />
          </AppCardGrid>
        ))}
      </AppCardGridContainer>
      <VersionInfo />
    </>
  );
}

export default MainMenu;
