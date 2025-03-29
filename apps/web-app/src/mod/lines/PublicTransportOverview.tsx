import AppCardGridContainer from '../../ui/AppCardGridContainer';
import AppPage from '../../ui/AppPage';
import AppPageHeadline from '../../ui/AppPageHeadline';
import ModuleSettingsButton from '../../ui/ModuleSettingsButton';
import PublicTransportLineCard from './PublicTransportLineCard';
import useLines from './useLines';
import usePublicTransportSettings from './usePublicTransportSettings';
import Grid from '@mui/material/Grid';

function PublicTransportOverview() {
  const lines = useLines();
  const settings = usePublicTransportSettings();

  return (
    <AppPage>
      <AppPageHeadline rightSettings={<ModuleSettingsButton settings={settings} />}>ÖPNV</AppPageHeadline>
      <AppCardGridContainer>
        {lines.map((i) => (
          <Grid size={{ xs: 12 }} key={i.id}>
            <PublicTransportLineCard line={i} />
          </Grid>
        ))}
      </AppCardGridContainer>
    </AppPage>
  );
}

export default PublicTransportOverview;
