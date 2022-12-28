import { AppBar, Box, Card, CardContent, IconButton, Toolbar, Typography } from '@mui/material';
import MenuIcon from '@mui/icons-material/Menu';
import StatusGrid from '../status/StatusGrid';
import MainMenu from './MainMenu';
import VersionInfo from './VersionInfo';

function AppHome() {
  return (
    <div className="Client">
      <Box sx={{ backgroundColor: '#f5f5f5', minHeight: '100vh' }}>
        <AppBar>
          <Toolbar>
            <IconButton size="large" edge="start" color="inherit" aria-label="menu" sx={{ mr: 2 }}>
              <MenuIcon />
            </IconButton>
            <Typography variant="h6" component="div" sx={{ flexGrow: 1, display: 'block' }}>
              Web-App für EEP
            </Typography>
          </Toolbar>
        </AppBar>
        <Toolbar />
        <MainMenu />
        <VersionInfo />
        <StatusGrid />
      </Box>
    </div>
  );
}

export default AppHome;
