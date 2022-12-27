import './ClientMain.css';
import { AppBar, Box, Container, Card, CardContent, IconButton, Stack, Toolbar, Typography } from '@mui/material';
import MenuIcon from '@mui/icons-material/Menu';
import StatusGrid from '../status/StatusGrid';

function ClientMain() {
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
        <StatusGrid />
      </Box>
    </div>
  );
}

export default ClientMain;
