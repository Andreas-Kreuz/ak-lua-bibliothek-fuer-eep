// Font Import for the Theme
import '@fontsource/anek-latin/300.css';
import '@fontsource/anek-latin/400.css';
import '@fontsource/anek-latin/500.css';
import '@fontsource/anek-latin/700.css';
import { createTheme } from '@mui/material/styles';
import { grey, indigo, lime, yellow } from '@mui/material/colors';

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
    MuiCardMedia: {
      styleOverrides: {
        root: {
          borderRadius: borderRadius,
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
          // borderColor: '#aaa',
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
