import { lazy } from 'react';
const ClientAppMainPage = lazy(() => import('./ClientAppMainPage'));
const StatusSnackBar = lazy(() => import('../status/StatusSnackBar'));
import LogMod from '../mod/log/LogMod';

function ClientAppMainPageWithSnack() {
  return (
    <div>
      <ClientAppMainPage />
      <StatusSnackBar />
      <LogMod />
    </div>
  );
}

export default ClientAppMainPageWithSnack;
