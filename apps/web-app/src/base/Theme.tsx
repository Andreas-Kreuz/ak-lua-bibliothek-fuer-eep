// Font Import for the Theme
import '@fontsource/anek-latin/300.css';
import '@fontsource/anek-latin/400.css';
import '@fontsource/anek-latin/500.css';
import '@fontsource/anek-latin/700.css';
import { grey, indigo, lime, yellow } from '@mui/material/colors';
import { createTheme } from '@mui/material/styles';

const borderRadius = 12;

export const theme = createTheme({
  palette: {
    background: {
      default: grey[200],
    },
    primary: {
      main: indigo[700],
    },
    secondary: {
      main: yellow[800],
    },
  },
  typography: {
    fontSize: 16,
    fontFamily: ['"Anek Latin"', 'sans-serif'].join(','),
  },
  shape: {
    borderRadius: borderRadius,
  },
  components: {
    MuiAppBar: {
      defaultProps: {
        variant: 'elevation',
        elevation: 10,
      },
    },
    MuiButton: {
      styleOverrides: {
        root: {
          borderRadius: 6,
        },
      },
    },
    MuiCard: {
      defaultProps: {
        elevation: 3,
        variant: 'elevation',
      },
      styleOverrides: {
        root: {
          borderRadius: borderRadius,
        },
      },
    },
    MuiCardMedia: {
      styleOverrides: {
        root: {
          borderRadius: borderRadius,
        },
      },
    },
    MuiChip: {
      defaultProps: {
        variant: 'outlined',
      },
      styleOverrides: {
        root: {},
        filled: {},
      },
    },
    MuiPaper: {
      defaultProps: {
        variant: 'outlined',
      },
    },
  },
});
