import AppBar from '@mui/material/AppBar';
import Box from '@mui/material/Box';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import { Outlet } from 'react-router-dom';
import LogView from '../mod/log/LogView';

function AppHome() {
  return (
    <div className="Client">
      <Box sx={{ minHeight: '100vh' }}>
        <AppBar>
          <Toolbar>
            {/* <IconButton size="large" edge="start" color="inherit" aria-label="menu" sx={{ mr: 2 }}>
              <MenuIcon />
            </IconButton> */}
            <Typography variant="h6" component="div" sx={{ flexGrow: 1, display: 'block' }}>
              App für EEP
            </Typography>
          </Toolbar>
        </AppBar>
        <Toolbar />
        <Outlet />
      </Box>
      <LogView />
    </div>
  );
}

export default AppHome;
