import SocketProvidedApp from './SocketProvidedApp';
import { ThemeProvider } from '@mui/material/styles';
import { CssBaseline } from '@mui/material';
import { theme } from './Theme';

function ThemedApp() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <SocketProvidedApp />
    </ThemeProvider>
  );
}

export default ThemedApp;
