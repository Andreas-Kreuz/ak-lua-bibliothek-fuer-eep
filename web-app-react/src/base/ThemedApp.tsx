import CssBaseline from '@mui/material/CssBaseline';
import { ThemeProvider } from '@mui/material/styles';
import { theme } from './Theme';
import SocketProvider from '../io/SocketProvider';
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
