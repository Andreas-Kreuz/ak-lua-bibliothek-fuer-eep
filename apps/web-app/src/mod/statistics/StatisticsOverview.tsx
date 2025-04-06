import { lazy } from 'react';
const AppCardGridContainer = lazy(() => import('../../ui/AppCardGridContainer'));
const AppPage = lazy(() => import('../../ui/AppPage'));
import StatisticsCard from './StatisticsCard';
import useStatistics from './useStatistics';

function StatisticsOverview() {
  const [updateTimes, initializationTimes, controllerUpdateTimes] = useStatistics();

  return (
    <AppPage>
      <AppCardGridContainer>
        <StatisticsCard title="Updates je Lua Modul" times={updateTimes} />
        <StatisticsCard title="Intialisierung je Lua Modul" times={initializationTimes} maxEntries={1} />
        <StatisticsCard title="Server" times={controllerUpdateTimes} />
      </AppCardGridContainer>
    </AppPage>
  );
}

export default StatisticsOverview;
