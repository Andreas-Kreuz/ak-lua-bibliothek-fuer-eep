import AppHome from './AppHome';
import StatusSnackBar from '../status/StatusSnackBar';

function AppHomeWithSnack() {
  return (
    <div className="Client">
      <AppHome />
      <StatusSnackBar />
    </div>
  );
}

export default AppHomeWithSnack;
