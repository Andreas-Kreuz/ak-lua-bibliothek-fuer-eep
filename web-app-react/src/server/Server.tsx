import { AppBar, Toolbar, IconButton, Typography } from '@mui/material';
import Box from '@mui/material/Box';
import StatusGrid from '../status/StatusGrid';
import './Server.css';
import { useServerStatus } from '../status/StatusEffectHook';
import ServerHome from './ServerHome';

function Server() {
  const [isConnected] = useServerStatus();

  return (
    <div className="Server">
      <Box sx={{ minHeight: '100vh' }}>
        <AppBar position="static">
          <Toolbar>
            <Typography variant="h6" component="div" sx={{ flexGrow: 1, display: 'block' }}>
              Web-Server für EEP
            </Typography>
          </Toolbar>
        </AppBar>
        <ServerHome />
        {/* <StatusGrid /> */}
      </Box>
    </div>
  );
}

export default Server;
