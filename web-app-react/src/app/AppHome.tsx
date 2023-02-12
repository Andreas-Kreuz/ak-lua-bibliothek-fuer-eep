import AppBar from '@mui/material/AppBar';
import Box from '@mui/material/Box';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import MainMenu from './MainMenu';
import VersionInfo from './VersionInfo';

function AppHome() {
  return (
    <div className="Client">
      <Box sx={{ backgroundColor: '#f5f5f5', minHeight: '100vh' }}>
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
        <MainMenu />
        <VersionInfo />
        {/* <StatusGrid /> */}
      </Box>
    </div>
  );
}

export default AppHome;
