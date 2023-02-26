import './ServerHome.css';
import Alert from '@mui/material/Alert';
import Autocomplete from '@mui/material/Autocomplete';
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogTitle from '@mui/material/DialogTitle';
import Divider from '@mui/material/Divider';
import Link from '@mui/material/Link';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import Paper from '@mui/material/Paper';
import Stack from '@mui/material/Stack';
import TextField from '@mui/material/TextField';
import Typography from '@mui/material/Typography';
import CheckCircleOutlineRoundedIcon from '@mui/icons-material/CheckCircleOutlineRounded';
import WarningRoundedIcon from '@mui/icons-material/WarningRounded';
import QRCode from 'react-qr-code';
import { useState } from 'react';
import { ServerStatusEvent, SettingsEvent } from '@ak/web-shared';
import { useSocket } from '../io/SocketProvider';
import { useRoomHandler } from '../io/useRoomHandler';

function ServerHome() {
  const [serverHost, setServerHost] = useState<string>();
  const [directoryName, setDirectoryName] = useState<string>('-');
  const [editedDirectoryName, setEditedDirectoryName] = useState<string>(directoryName);
  const [directoryOk, setDirectoryOk] = useState<boolean | null>(null);
  const [data, setData] = useState<string[]>([]);
  const [eventCount, setEventCount] = useState(0);
  const [open, setOpen] = useState(false);

  const webAppUrl =
    window.location.protocol + '//' + (serverHost ? serverHost : window.location.hostname) + ':' + window.location.port;

  const code = `local ModuleRegistry = require("ak.core.ModuleRegistry")
ModuleRegistry.registerModules(require("ak.core.CoreLuaModule"))

function EEPMain()
    ModuleRegistry.runTasks()
    return 1
end`;

  const socket = useSocket();

  useRoomHandler(ServerStatusEvent.Room, [
    {
      eventName: ServerStatusEvent.UrlsChanged,
      handler: (payload: string) => {
        const urls: string[] = JSON.parse(payload);
        setData(urls);
      },
    },
    {
      eventName: ServerStatusEvent.CounterUpdated,
      handler: (payload: string) => {
        const eventCounter: number = JSON.parse(payload);
        setEventCount(eventCounter);
      },
    },
  ]);

  useRoomHandler(SettingsEvent.Room, [
    { eventName: SettingsEvent.Host, handler: (payload) => setServerHost(payload) },
    {
      eventName: SettingsEvent.DirOk,
      handler: (payload: string) => {
        setDirectoryOk(true);
        setDirectoryName(payload);
        setEditedDirectoryName(payload);
      },
    },
    {
      eventName: SettingsEvent.DirError,
      handler: (payload: string) => {
        setDirectoryOk(false);
        setDirectoryName(payload);
        setEditedDirectoryName(payload);
      },
    },
  ]);

  const handleClickOpen = () => {
    setEditedDirectoryName(directoryName);
    setOpen(true);
  };
  const handleCloseCancel = () => {
    setOpen(false);
  };
  const handleCloseChoose = () => {
    setOpen(false);
    socket.emit(SettingsEvent.ChangeDir, editedDirectoryName);
  };

  const eepInstallations = ['C:\\Trend\\EEP17', 'C:\\Trend\\EEP16'];

  if (directoryOk === null) {
    return (
      <Box sx={{ width: '100%', height: '90vh', display: 'flex' }}>
        <Paper sx={{ margin: 'auto', padding: 2, display: 'inline' }}>Daten werden geladen ...</Paper>
      </Box>
    );
  }

  return (
    <Stack spacing={3} sx={{ padding: 3 }}>
      {directoryOk ? (
        <>
          <Alert
            severity="success"
            sx={{
              border: 1,
              borderColor: 'success.main',
              py: 1,
              pl: 2,
              pr: 3,
              alignItems: 'center',
            }}
            icon={<CheckCircleOutlineRoundedIcon />}
            action={
              <Box sx={{ display: 'flex', alignItems: 'center' }}>
                <Link href={webAppUrl} target="_blank" rel="noreferrer" underline="none" sx={{ ml: 4 }}>
                  <Button id="App öffnen" variant="contained" color={'success'}>
                    App öffnen
                  </Button>
                </Link>
              </Box>
            }
          >
            <Typography variant="body1">Es ist alles bereit. Du kannst die App öffnen.</Typography>
            <Typography variant="body2">{webAppUrl}</Typography>
          </Alert>
          <Paper
            elevation={0}
            sx={{
              border: 1,
              borderColor: '#aaaaaa',
              display: 'flex',
              flexDirection: 'row',
              alignItems: 'center',
              justifyContent: 'flex-start',
              py: 1,
              px: 2,
              pr: 3,
            }}
          >
            <CheckCircleOutlineRoundedIcon sx={{ mr: 1.5, color: 'success.main' }} />
            <Box sx={{ flexGrow: 1 }}>
              <Typography variant="body1">Scanne den QR-Code rechts mit Deinem Tablet oder Smartphone.</Typography>
              <Typography variant="body2">Dein Smartphone muss dazu im selben WLAN sein.</Typography>
            </Box>
            <QRCode value={webAppUrl} size={64} />
          </Paper>
        </>
      ) : (
        ''
      )}
      <Paper
        variant="outlined"
        sx={{
          p: 0,
          borderWidth: 1,
          borderColor: '#aaaaaa',
        }}
      >
        <List sx={{ py: 0 }}>
          <ListItem>
            <Stack sx={{ width: 1 }}>
              {directoryOk ? (
                ''
              ) : (
                <div>
                  <Alert severity="warning" sx={{ mt: 1, mb: 2 }} icon={<WarningRoundedIcon />}>
                    <Typography variant="body1" gutterBottom>
                      Bevor es losgeht, muss Du nur noch den Ordner von EEP angeben.
                    </Typography>
                    <Typography variant="body2" gutterBottom>
                      Gib den Ordner an, in dem EEP installiert ist. <br />
                      Der Server sucht nach dem Verzeichnis &quot;LUA/ak/io/exchange&quot;.
                      <br />
                      Die Lua-Bibliothek muss installiert sein. <br />
                    </Typography>
                  </Alert>
                </div>
              )}
              <Stack
                sx={{
                  m: 0,
                  p: 0,
                  width: 1,
                  flexDirection: 'row',
                  alignItems: 'center',
                  justifyContent: 'space-between',
                }}
              >
                {directoryOk ? <CheckCircleOutlineRoundedIcon sx={{ mr: 1.5, color: 'success.main' }} /> : ''}
                <Box sx={{ flexGrow: 1 }}>
                  <div>
                    <Typography variant="body1">EEP Ordner</Typography>
                    <Typography variant="body2" id="choose-dir-current-dir">
                      {directoryName}
                    </Typography>
                  </div>
                </Box>
                <Button
                  id="choose-dir-button"
                  variant={directoryOk ? 'text' : 'contained'}
                  color={directoryOk ? 'primary' : 'warning'}
                  onClick={handleClickOpen}
                >
                  Ordner wählen
                </Button>
              </Stack>
            </Stack>
          </ListItem>
          {directoryOk ? <Divider /> : ''}
          {data.length > 0 && directoryOk ? (
            <ListItem>
              <Stack
                sx={{
                  m: 0,
                  p: 0,
                  width: 1,
                  flexDirection: 'row',
                  alignItems: 'start',
                  justifyContent: 'space-between',
                }}
              >
                <CheckCircleOutlineRoundedIcon sx={{ mt: 1.0, mr: 1.5, color: 'success.main' }} />
                <Box sx={{ flexGrow: 1 }}>
                  <Typography variant="subtitle1">
                    Bereitgestellte Daten aus {eventCount.toLocaleString()} Events:
                  </Typography>
                  <Typography variant="body2">{data.join(', ')}</Typography>
                </Box>
              </Stack>
            </ListItem>
          ) : (
            ''
          )}
          {!directoryOk ? (
            <ListItem>
              <Stack sx={{ width: 1 }}>
                <div>
                  <Alert severity="warning" sx={{ mx: 0, mb: 2 }} icon={<WarningRoundedIcon />}>
                    Es wurden keine Daten von EEP gesammelt.
                    <br />
                    Stelle sicher, dass Du den folgenden Lua-Code in EEP eingetragen hast.
                  </Alert>
                  <pre>{code}</pre>
                </div>
              </Stack>
            </ListItem>
          ) : (
            ''
          )}
        </List>
        <Dialog open={open} onClose={handleCloseCancel} aria-labelledby="responsive-dialog-title" sx={{ width: 1 }}>
          <DialogTitle id="responsive-dialog-title">EEP Verzeichnis</DialogTitle>
          <DialogContent>
            <DialogContentText>
              Bitte wähle den Ordner, in dem Dein EEP installiert wurde, wie z.B. C:\TREND\EEP17
            </DialogContentText>
            <Autocomplete
              id="dir-dialog-dir"
              value={editedDirectoryName}
              onInputChange={(event, value) => setEditedDirectoryName(value)}
              disablePortal
              options={eepInstallations}
              sx={{ width: 1, my: 2 }}
              renderInput={(params) => <TextField {...params} label="EEP-Ordner" />}
            />
            <DialogContentText>
              Mit der Auswahl des richtigen Ordners kann der Server auf die Ausgaben der Lua-Bibliothek zugreifen.
            </DialogContentText>
          </DialogContent>
          <DialogActions>
            <Button id="dir-dialog-cancel" onClick={handleCloseCancel} autoFocus>
              Abbrechen
            </Button>
            <Button
              id="dir-dialog-choose"
              autoFocus
              onClick={handleCloseChoose}
              disabled={!editedDirectoryName || editedDirectoryName.length === 0}
            >
              Wählen
            </Button>
          </DialogActions>
        </Dialog>
      </Paper>
    </Stack>
  );
}

export default ServerHome;
