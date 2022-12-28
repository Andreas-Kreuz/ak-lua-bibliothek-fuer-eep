import ClientMain from './ClientMain';
import StatusSnackBar from '../status/StatusSnackBar';

function Client() {
  return (
    <div className="Client">
      <ClientMain />
      <StatusSnackBar />
    </div>
  );
}

export default Client;
