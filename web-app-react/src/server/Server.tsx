import Box from '@mui/material/Box';
import './Server.css';
import { useServerStatus } from '../status/StatusEffectHook';
import ServerHome from './ServerHome';
import AppBar from '@mui/material/AppBar';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';

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
