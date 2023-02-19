import AppBar from '@mui/material/AppBar';
import Box from '@mui/material/Box';
import { useTheme } from '@mui/material/styles';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import { Outlet } from 'react-router-dom';
import LogView from '../mod/log/LogView';
import AppBackButton from '../ui/AppBackButton';
import { Link as RouterLink } from 'react-router-dom';

function AppHome() {
  const theme = useTheme();
  return (
    <div className="Client">
      <Box sx={{ minHeight: '100vh' }}>
        <AppBar>
          <Toolbar>
            <AppBackButton sx={{ mr: 2, color: theme.palette.primary.contrastText }} />
            <Typography
              variant="h6"
              component={RouterLink}
              to={'/'}
              sx={{ flexGrow: 1, display: 'block', textDecoration: 'none', color: theme.palette.primary.contrastText }}
            >
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
