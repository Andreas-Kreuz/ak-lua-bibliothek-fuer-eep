import { lazy, useMemo } from 'react';
import { ThemeProvider as MuiThemeProvider } from '@mui/material/styles';
import { theme } from './Theme';
import CssBaseline from '@mui/material/CssBaseline';
const SocketProvider = lazy(() => import('../io/SocketProvider'));
const RoutedApp = lazy(() => import('./RoutedApp'));

function ThemedApp() {
  return useMemo(
    () => (
      <MuiThemeProvider theme={theme}>
        <SocketProvider>
          <CssBaseline />
          <RoutedApp />
        </SocketProvider>
      </MuiThemeProvider>
    ),
    [theme],
  );
}

export default ThemedApp;
