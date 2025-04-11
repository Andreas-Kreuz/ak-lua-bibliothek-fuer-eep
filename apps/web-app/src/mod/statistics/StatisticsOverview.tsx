import { lazy } from 'react';
const AppCardGridContainer = lazy(() => import('../../ui/AppCardGridContainer'));
const AppPage = lazy(() => import('../../ui/AppPage'));
import StatisticsCard from './StatisticsCard';
import useStatistics from './useStatistics';
import AppPageHeadline from '../../ui/AppPageHeadline';
import VersionInfo from '../../status/VersionInfo';

function StatisticsOverview() {
  const [updateTimes, initializationTimes, controllerUpdateTimes] = useStatistics();

  return (
    <AppPage>
      <AppPageHeadline>Statistik</AppPageHeadline>
      <VersionInfo />
      <AppCardGridContainer>
        <StatisticsCard title="Berechnung Lua Module" times={updateTimes} />
        <StatisticsCard title="Initialisierung Lua Module" times={initializationTimes} maxEntries={1} />
        <StatisticsCard title="Server" times={controllerUpdateTimes} />
      </AppCardGridContainer>
    </AppPage>
  );
}

export default StatisticsOverview;
