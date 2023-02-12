import CssBaseline from '@mui/material/CssBaseline';
import { ThemeProvider } from '@mui/material/styles';
import { theme } from './Theme';
import SocketProvidedApp from './SocketProvidedApp';

function ThemedApp() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <SocketProvidedApp />
    </ThemeProvider>
  );
}

export default ThemedApp;
