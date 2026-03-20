import { Divider as MuiDivider } from '@mui/material';
import MuiBackdrop from '@mui/material/Backdrop';
import MuiCircularProgress from '@mui/material/CircularProgress';
import MuiPaper from '@mui/material/Paper';
import MuiStack from '@mui/material/Stack';
import MuiTypography from '@mui/material/Typography';

export interface ConnectingScreenProps {
  url: string;
}

const ConnectingScreen = (props: ConnectingScreenProps) => {
  return (
    <MuiBackdrop open>
      <MuiPaper sx={{ m: { xs: 1, sm: 'auto' }, p: { xs: 2, md: 4 }, borderRadius: 2 }} variant="outlined">
        <MuiStack sx={{ alignItems: 'center' }} spacing={1}>
          <MuiTypography gutterBottom>
            Verbinde zum Server für EEP an{' '}
            <strong style={{ fontWeight: 500, wordBreak: 'break-word' }}>{props.url}</strong> ...
          </MuiTypography>
          <MuiCircularProgress />
        </MuiStack>
        <MuiDivider sx={{ my: 2 }} />
        <MuiTypography gutterBottom>
          <img
            src={'/icon-192.png'}
            style={{ height: 48, float: 'left', marginRight: '1rem' }}
          ></img>
          <strong>Hast Du den Server für EEP beendet?</strong>
          <br />
          Schließe diese Seite oder starte den Server erneut.
        </MuiTypography>
      </MuiPaper>
    </MuiBackdrop>
  );
};

export default ConnectingScreen;
