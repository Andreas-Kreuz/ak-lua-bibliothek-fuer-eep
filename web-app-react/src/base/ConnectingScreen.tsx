import Backdrop from '@mui/material/Backdrop';
import CircularProgress from '@mui/material/CircularProgress';
import Paper from '@mui/material/Paper';
import Stack from '@mui/material/Stack';
import Typography from '@mui/material/Typography';
import { socketUrl } from './SocketProvidedApp';

function ConnectingScreen() {
  return (
    <Backdrop open>
      <Paper sx={{ m: 'auto', p: 4, borderRadius: 2 }} variant="outlined">
        <Stack sx={{ alignItems: 'center' }} spacing={1}>
          <Typography sx={{ mb: 3 }}>
            <strong>Hast Du den Server für EEP beendet?</strong>
          </Typography>
          <Typography>Die Verbindung wurde unterbrochen</Typography>
          <CircularProgress />
          <Typography>Ich versuche {socketUrl} zu erreichen.</Typography>
        </Stack>
      </Paper>
    </Backdrop>
  );
}

export default ConnectingScreen;
