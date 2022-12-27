// Font Import for the Theme
import '@fontsource/anek-latin/300.css';
import '@fontsource/anek-latin/400.css';
import '@fontsource/anek-latin/500.css';
import '@fontsource/anek-latin/700.css';

import { createTheme } from '@mui/material';

export const theme = createTheme({
  palette: {
    primary: {
      main: '#303f9f',
    },
    secondary: {
      main: '#f9a825',
    },
  },
  typography: {
    fontSize: 16,
    fontFamily: ['"Anek Latin"', 'sans-serif'].join(','),
  },
});
