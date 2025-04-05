import AppCardGridContainer from '../../ui/AppCardGridContainer';
import AppPage from '../../ui/AppPage';
import StatisticsCard from './StatisticsCard';
import { Grid } from '@mui/material';
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
