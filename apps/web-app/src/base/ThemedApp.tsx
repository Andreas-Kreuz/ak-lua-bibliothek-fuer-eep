import { lazy } from 'react';
import CssBaseline from '@mui/material/CssBaseline';
import { ThemeProvider } from '@mui/material/styles';
import { theme } from './Theme';
const SocketProvider = lazy(() => import('../io/SocketProvider'));
import RoutedApp from './RoutedApp';

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
