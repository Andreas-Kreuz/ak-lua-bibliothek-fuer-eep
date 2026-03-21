import { lazy } from 'react';
import ModuleSettingsButton from '../../ui/ModuleSettingsButton';
import useLines from './useLines';
import useTransitSettings from './useTransitSettings';
import Grid from '@mui/material/Grid';
const AppCardGridContainer = lazy(() => import('../../ui/AppCardGridContainer'));
const AppPage = lazy(() => import('../../ui/AppPage'));
const AppPageHeadline = lazy(() => import('../../ui/AppPageHeadline'));
const TransitLineCard = lazy(() => import('./TransitLineCard'));

function TransitOverview() {
  const lines = useLines();
  const settings = useTransitSettings();

  return (
    <AppPage>
      <AppPageHeadline rightSettings={<ModuleSettingsButton settings={settings} />}>ÖPNV</AppPageHeadline>
      <AppCardGridContainer>
        {lines.map((i) => (
          <Grid size={{ xs: 12 }} key={i.id}>
            <TransitLineCard line={i} />
          </Grid>
        ))}
      </AppCardGridContainer>
    </AppPage>
  );
}

export default TransitOverview;
