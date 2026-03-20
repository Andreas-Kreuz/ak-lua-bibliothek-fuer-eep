import { lazy } from 'react';
const AppCardGridContainer = lazy(() => import('../../ui/AppCardGridContainer'));
const AppPage = lazy(() => import('../../ui/AppPage'));
import StatisticsCard from './StatisticsCard';
import useStatistics from './useStatistics';
import AppPageHeadline from '../../ui/AppPageHeadline';
import VersionInfoWrapper from './VersionInfoWrapper';

function StatisticsOverview() {
  const [publisherSyncTimes, initializationTimes, controllerUpdateTimes, moduleInitTimes, publisherInitTimes] =
    useStatistics();

  return (
    <AppPage>
      <AppPageHeadline>Statistik</AppPageHeadline>
      <AppCardGridContainer>
        <VersionInfoWrapper />
        <StatisticsCard title="Ausführung der Publisher" times={publisherSyncTimes} />
        <StatisticsCard title="Ausführung CeModule" times={publisherInitTimes} />
        <StatisticsCard title="Server" times={controllerUpdateTimes} />
        <StatisticsCard title="Initialisierung CeModule" times={moduleInitTimes} maxEntries={1} />
        <StatisticsCard title="Initialisierung der Publisher" times={initializationTimes} maxEntries={1} />
      </AppCardGridContainer>
    </AppPage>
  );
}

export default StatisticsOverview;
