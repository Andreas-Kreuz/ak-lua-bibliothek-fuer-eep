import AppCardBg from '../../ui/AppCardBg';
import AppCardGrid from '../../ui/AppCardGrid';
import AppCardGridContainer from '../../ui/AppCardGridContainer';
import AppPage from '../../ui/AppPage';
import AppPageHeadline from '../../ui/AppPageHeadline';
import ModuleSettingsButton from '../../ui/ModuleSettingsButton';
import useLines from './useLines';
import usePublicTransportSettings from './usePublicTransportSettings';
import BusIcon from '@mui/icons-material/DirectionsBus';
import LocationOnIcon from '@mui/icons-material/LocationOn';
import TramIcon from '@mui/icons-material/Tram';
import Chip from '@mui/material/Chip';

function PublicTransportOverview() {
  const lines = useLines();
  const settings = usePublicTransportSettings();

  return (
    <AppPage>
      <AppPageHeadline rightSettings={<ModuleSettingsButton settings={settings} />}>ÖPNV</AppPageHeadline>
      <AppCardGridContainer>
        {lines.map((i) => (
          <AppCardGrid key={i.id}>
            <AppCardBg
              title={`Linie ${i.id}`}
              image="/assets/card-img-traffic.jpg"
              // to={`/public-transport/${i.id}`}
              additionalChips={i.lineSegments.map((el) => (
                <Chip key={el.destination} variant="outlined" label={el.destination} icon={getIcon(i.trafficType)} />
              ))}
            ></AppCardBg>
          </AppCardGrid>
        ))}
      </AppCardGridContainer>
    </AppPage>
  );
}

function getIcon(trafficType: string) {
  switch (trafficType) {
    default:
    case 'BUS':
      return <BusIcon />;
    case 'TRAM':
      return <TramIcon />;
  }
}

export default PublicTransportOverview;
