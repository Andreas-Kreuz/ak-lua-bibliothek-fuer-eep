import AppHome from './AppHome';
import StatusSnackBar from '../status/StatusSnackBar';

function AppHomeWithSnack() {
  return (
    <div>
      <AppHome />
      <StatusSnackBar />
    </div>
  );
}

export default AppHomeWithSnack;
