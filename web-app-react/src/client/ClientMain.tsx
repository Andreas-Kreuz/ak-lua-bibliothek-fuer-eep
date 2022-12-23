import './ClientMain.css';
import { AppBar, Card, CardContent, IconButton, Stack, Toolbar, Typography } from '@mui/material';
import Grid from '@mui/material/Unstable_Grid2'; // Grid version 2
import WarningRoundedIcon from '@mui/icons-material/WarningRounded';
import CheckCircleOutlineRoundedIcon from '@mui/icons-material/CheckCircleOutlineRounded';
import RunningWithErrorsRoundedIcon from '@mui/icons-material/RunningWithErrorsRounded';
import Container from '@mui/material/Container';
import MenuIcon from '@mui/icons-material/Menu';
import Box from '@mui/material/Box/Box';
import { useServerStatus } from '../server/ServerStatusEffectHook';

function ClientMain() {
  const [isConnected, eepDataUpToDate, luaDataReceived, apiEntryCount] = useServerStatus();

  return (
    <div className="Client">
      <Box sx={{ backgroundColor: '#f5f5f5', minHeight: '100vh' }}>
        <AppBar>
          <Toolbar>
            <IconButton size="large" edge="start" color="inherit" aria-label="menu" sx={{ mr: 2 }}>
              <MenuIcon />
            </IconButton>
            <Typography variant="h6" component="div" sx={{ flexGrow: 1, display: 'block' }}>
              Aktueller Status
            </Typography>
          </Toolbar>
        </AppBar>
        <Toolbar />
        <Container>
          <Grid container paddingTop={3} spacing={3}>
            <Grid sm={4}>
              <Card className="card">
                <CardContent>
                  <Stack direction="row" alignItems="center" justifyContent="space-between">
                    <Typography
                      className="cardTitleWithIcon"
                      variant="h5"
                      color={isConnected ? 'success.main' : 'error.main'}
                      component="div"
                    >
                      Web-Server
                    </Typography>
                    {isConnected ? (
                      <CheckCircleOutlineRoundedIcon color="success" sx={{ fontSize: 24 }} />
                    ) : (
                      <WarningRoundedIcon color="error" />
                    )}
                  </Stack>
                  <Typography
                    gutterBottom
                    variant="body2"
                    color={isConnected ? 'success.main' : 'error.main'}
                    sx={{ fontWeight: 'bold' }}
                  >
                    {isConnected ? 'OK' : 'Server nicht erreichbar'}
                  </Typography>
                  <Typography variant="body2">
                    Diese Webseite zeigt nur aktuelle Informationen an, wenn sie den Web-Server erreicht.
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
            <Grid sm={4}>
              <Card className="card">
                <CardContent>
                  <Stack direction="row" alignItems="center" justifyContent="space-between">
                    <Typography
                      className="cardTitleWithIcon"
                      variant="h5"
                      color={isConnected && luaDataReceived ? 'success.main' : 'error.main'}
                      component="div"
                    >
                      LUA-Bibliothek
                    </Typography>
                    {isConnected ? (
                      luaDataReceived ? (
                        <CheckCircleOutlineRoundedIcon color="success" sx={{ fontSize: 24 }} />
                      ) : (
                        <WarningRoundedIcon color="error" />
                      )
                    ) : (
                      <WarningRoundedIcon color="error" />
                    )}
                  </Stack>
                  <Typography
                    gutterBottom
                    variant="body2"
                    color={isConnected && luaDataReceived ? 'success.main' : 'error.main'}
                    sx={{ fontWeight: 'bold' }}
                  >
                    {isConnected
                      ? luaDataReceived
                        ? 'OK'
                        : 'Bibliothek nicht eingebunden'
                      : 'Server nicht erreichbar'}
                  </Typography>
                  <Typography variant="body2">
                    {isConnected
                      ? luaDataReceived
                        ? 'Es stehen ' + apiEntryCount + ' verschiedene Informationen zur Verfügung'
                        : 'Konfiguriere die Lua-Bibliothek in EEP, damit Du Informationen anzeigen kannst'
                      : 'Diese Webseite zeigt nur aktuelle Informationen an, wenn sie den Web-Server erreicht.'}
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
            <Grid sm={4}>
              <Card className="card">
                <CardContent>
                  <Stack direction="row" alignItems="center" justifyContent="space-between">
                    <Typography
                      className="cardTitleWithIcon"
                      variant="h5"
                      color={isConnected ? (eepDataUpToDate ? 'success.main' : 'warning.main') : 'error.main'}
                      component="div"
                    >
                      EEP
                    </Typography>
                    {isConnected ? (
                      eepDataUpToDate ? (
                        <CheckCircleOutlineRoundedIcon color="success" sx={{ fontSize: 24 }} />
                      ) : (
                        <RunningWithErrorsRoundedIcon color="warning" />
                      )
                    ) : (
                      <WarningRoundedIcon color="error" />
                    )}
                  </Stack>
                  <Typography
                    gutterBottom
                    variant="body2"
                    color={isConnected ? (eepDataUpToDate ? 'success.main' : 'warning.main') : 'error.main'}
                    sx={{ fontWeight: 'bold' }}
                  >
                    {isConnected ? (eepDataUpToDate ? 'OK' : 'Daten nicht aktuell') : 'Server nicht erreichbar'}
                  </Typography>
                  <Typography variant="body2">
                    {isConnected
                      ? eepDataUpToDate
                        ? 'Wenn EEP pausiert ist, dann werden keine Updates empfangen und keine Befehle entgegengenommen.'
                        : 'Wenn EEP pausiert ist, dann werden keine Updates empfangen und keine Befehle entgegengenommen.'
                      : 'Diese Webseite zeigt nur aktuelle Informationen an, wenn sie den Web-Server erreicht.'}
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
          </Grid>
        </Container>
      </Box>
    </div>
  );
}

export default ClientMain;
