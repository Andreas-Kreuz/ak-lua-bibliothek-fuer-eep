import { AppBar, Toolbar, IconButton, Typography } from '@mui/material';
import Box from '@mui/material/Box';
import StatusGrid from '../status/StatusGrid';
import './Server.css';
import { useServerStatus } from '../status/ServerStatusEffectHook';
import MenuIcon from '@mui/icons-material/Menu';

function Server() {
  const [isConnected] = useServerStatus();

  return (
    <div className="Server">
      <Box sx={{ backgroundColor: '#f5f5f5' }}>
        <AppBar position="static">
          <Toolbar>
            <IconButton size="large" edge="start" color="inherit" aria-label="menu" sx={{ mr: 2 }}>
              <MenuIcon />
            </IconButton>
            <Typography variant="h6" component="div" sx={{ flexGrow: 1, display: 'block' }}>
              Server Status
            </Typography>
          </Toolbar>
        </AppBar>
        <StatusGrid />
      </Box>
    </div>
  );
}

export default Server;
