import { lazy } from 'react';
const AppBackButton = lazy(() => import('../ui/AppBackButton'));
import AppBar from '@mui/material/AppBar';
import Box from '@mui/material/Box';
import { useTheme } from '@mui/material/styles';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import { Outlet } from 'react-router-dom';
import { Link as RouterLink } from 'react-router-dom';

function ClientAppMainPage() {
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
    </div>
  );
}

export default ClientAppMainPage;
