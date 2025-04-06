import { lazy } from 'react';
import { ThemeProvider } from '@mui/material/styles';
import { theme } from './Theme';
import CssBaseline from '@mui/material/CssBaseline';
const SocketProvider = lazy(() => import('../io/SocketProvider'));
const RoutedApp = lazy(() => import('./RoutedApp'));

function ThemedApp() {
  return (
    <ThemeProvider theme={theme}>
      <SocketProvider>
        <CssBaseline />
        <RoutedApp />
      </SocketProvider>
    </ThemeProvider>
  );
}

export default ThemedApp;
