import StatusCard from './StatusCard';
import { useServerStatus } from './useServerInfo';
import Grid from '@mui/material/Unstable_Grid2';
import { useSocketIsConnected } from '../io/SocketProvider';

function StatusGrid() {
  const isConnected = useSocketIsConnected();
  const [eepDataUpToDate, luaDataReceived, apiEntryCount] = useServerStatus();

  return (
    <Grid container spacing={3} sx={{ width: 'auto', m: 3 }}>
      <Grid xs={12}>
        <StatusCard
          name="Web-Server"
          icon={isConnected ? 'ok' : 'error'}
          statusColor={isConnected ? 'success' : 'error'}
          statusText={isConnected ? 'OK' : 'Server nicht erreichbar'}
          statusDescription="Diese Webseite zeigt nur aktuelle Informationen an, wenn sie den Web-Server erreicht."
        ></StatusCard>
      </Grid>
      <Grid xs={12}>
        <StatusCard
          name="LUA-Bibliothek"
          icon={isConnected && luaDataReceived ? 'ok' : 'error'}
          statusColor={isConnected && luaDataReceived ? 'success' : 'error'}
          statusText={
            isConnected ? (luaDataReceived ? 'OK' : 'Bibliothek nicht eingebunden') : 'Server nicht erreichbar'
          }
          statusDescription={
            isConnected
              ? luaDataReceived
                ? 'Die Lua-Bibliothek stellt ' + apiEntryCount + ' verschiedene Informationen zur Verfügung'
                : 'Konfiguriere die Lua-Bibliothek in EEP, damit Du Informationen anzeigen kannst'
              : 'Diese Webseite zeigt nur aktuelle Informationen an, wenn sie den Web-Server erreicht.'
          }
        />
      </Grid>
      <Grid xs={12}>
        <StatusCard
          name="EEP"
          icon={isConnected ? (eepDataUpToDate ? 'ok' : 'time') : 'error'}
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
