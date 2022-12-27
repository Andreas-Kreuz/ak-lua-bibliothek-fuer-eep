import { Unstable_Grid2 as Grid, Card, CardContent, Stack, Typography } from '@mui/material';
import CheckCircleOutlineRoundedIcon from '@mui/icons-material/CheckCircleOutlineRounded';
import RunningWithErrorsRoundedIcon from '@mui/icons-material/RunningWithErrorsRounded';
import WarningRoundedIcon from '@mui/icons-material/WarningRounded';
import StatusCard from '../status/StatusCard';
import { useServerStatus } from './ServerStatusEffectHook';

function StatusGrid() {
  const [isConnected, eepDataUpToDate, luaDataReceived, apiEntryCount] = useServerStatus();

  return (
    <Grid className="card-grid" container spacing={3} margin={3}>
      <Grid sm={4}>
        <StatusCard
          name="Web-Server"
          icon={
            isConnected ? (
              <CheckCircleOutlineRoundedIcon color="success" sx={{ fontSize: 24 }} />
            ) : (
              <WarningRoundedIcon color="error" sx={{ fontSize: 24 }} />
            )
          }
          statusColor={isConnected ? 'success' : 'error'}
          statusText={isConnected ? 'OK' : 'Server nicht erreichbar'}
          statusDescription="Diese Webseite zeigt nur aktuelle Informationen an, wenn sie den Web-Server erreicht."
        ></StatusCard>
      </Grid>
      <Grid sm={4}>
        <StatusCard
          name="LUA-Bibliothek"
          icon={
            isConnected ? (
              luaDataReceived ? (
                <CheckCircleOutlineRoundedIcon color="success" sx={{ fontSize: 24 }} />
              ) : (
                <WarningRoundedIcon color="error" />
              )
            ) : (
              <WarningRoundedIcon color="error" />
            )
          }
          statusColor={isConnected && luaDataReceived ? 'success' : 'error'}
          statusText={
            isConnected ? (luaDataReceived ? 'OK' : 'Bibliothek nicht eingebunden') : 'Server nicht erreichbar'
          }
          statusDescription={
            isConnected
              ? luaDataReceived
                ? 'Es stehen ' + apiEntryCount + ' verschiedene Informationen zur Verfügung'
                : 'Konfiguriere die Lua-Bibliothek in EEP, damit Du Informationen anzeigen kannst'
              : 'Diese Webseite zeigt nur aktuelle Informationen an, wenn sie den Web-Server erreicht.'
          }
        />
      </Grid>
      <Grid sm={4}>
        <StatusCard
          name="EEP"
          icon={
            isConnected ? (
              eepDataUpToDate ? (
                <CheckCircleOutlineRoundedIcon color="success" sx={{ fontSize: 24 }} />
              ) : (
                <RunningWithErrorsRoundedIcon color="warning" />
              )
            ) : (
              <WarningRoundedIcon color="error" />
            )
          }
          statusColor={isConnected ? (eepDataUpToDate ? 'success' : 'warning') : 'error'}
          statusText={isConnected ? (eepDataUpToDate ? 'OK' : 'Daten nicht aktuell') : 'Server nicht erreichbar'}
          statusDescription={
            isConnected
              ? eepDataUpToDate
                ? 'Wenn EEP pausiert ist, dann werden keine Updates empfangen und keine Befehle entgegengenommen.'
                : 'Wenn EEP pausiert ist, dann werden keine Updates empfangen und keine Befehle entgegengenommen.'
              : 'Diese Webseite zeigt nur aktuelle Informationen an, wenn sie den Web-Server erreicht.'
          }
        />
      </Grid>
    </Grid>
  );
}

export default StatusGrid;
