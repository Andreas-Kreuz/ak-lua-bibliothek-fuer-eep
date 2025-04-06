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
        <StatisticsCard title="Zeiten für das Update" times={updateTimes} />
        <StatisticsCard title="Zeit für die Intialisierung" times={initializationTimes} />
        <StatisticsCard title="Serverzeiten" times={controllerUpdateTimes} />
      </AppCardGridContainer>
    </AppPage>
  );
}

export default StatisticsOverview;
