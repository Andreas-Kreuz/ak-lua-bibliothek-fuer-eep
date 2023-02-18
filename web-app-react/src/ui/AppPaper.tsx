import { useTheme } from '@mui/material';
import Paper from '@mui/material/Paper';

function AppPaper(props: { children: React.ReactNode | React.ReactNode[]; image?: string }) {
  const theme = useTheme();

  return (
    <Paper
      sx={
        props.image
          ? {
              background:
                'radial-gradient(circle at right, ' +
                'rgba(255,255,255,0) 0px, rgba(255,255,255,0) 100px, rgba(255,255,255,1) 200px), ' +
                'url(' +
                props.image +
                ')',
              backgroundSize: 'auto 150%',
              backgroundPositionX: '100%',
              backgroundPositionY: '60%',
              backgroundRepeat: 'no-repeat',
              mt: { xs: theme.spacing(2), md: theme.spacing(5) },
              p: { xs: theme.spacing(2), md: theme.spacing(3) },
            }
          : {
              mt: { xs: theme.spacing(2), md: theme.spacing(5) },
              p: { xs: theme.spacing(2), md: theme.spacing(3) },
            }
      }
    >
      {props.children}
    </Paper>
  );
}

export default AppPaper;
