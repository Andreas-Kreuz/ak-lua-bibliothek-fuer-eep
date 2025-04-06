import { lazy } from 'react';
const AppHome = lazy(() => import('./AppHome'));
const StatusSnackBar = lazy(() => import('../status/StatusSnackBar'));

function AppHomeWithSnack() {
  return (
    <div>
      <AppHome />
      <StatusSnackBar />
    </div>
  );
}

export default AppHomeWithSnack;
