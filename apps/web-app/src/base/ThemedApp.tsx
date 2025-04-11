import { lazy, useMemo } from 'react';
import { ThemeProvider } from '@mui/material/styles';
import { theme } from './Theme';
import CssBaseline from '@mui/material/CssBaseline';
const SocketProvider = lazy(() => import('../io/SocketProvider'));
const RoutedApp = lazy(() => import('./RoutedApp'));

function ThemedApp() {
  return useMemo(
    () => (
      <ThemeProvider theme={theme}>
        <SocketProvider>
          <CssBaseline />
          <RoutedApp />
        </SocketProvider>
      </ThemeProvider>
    ),
    [theme],
  );
}

export default ThemedApp;
