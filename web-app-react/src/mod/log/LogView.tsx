import Paper from '@mui/material/Paper';
import ArrowUpIcon from '@mui/icons-material/KeyboardArrowUp';
import ArrowDownIcon from '@mui/icons-material/KeyboardArrowDown';
import LogLinesView from './LogLinesView';
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import useMediaQuery from '@mui/material/useMediaQuery';
import { useTheme } from '@mui/material/styles';
import Slide from '@mui/material/Slide';
import Divider from '@mui/material/Divider';
import Collapse from '@mui/material/Collapse';
import { useState } from 'react';
import { TransitionGroup } from 'react-transition-group';

function LogView() {
  const theme = useTheme();
  const matches = useMediaQuery(theme.breakpoints.up('md'));
  const [open, setOpen] = useState(true);
  theme.transitions.create(['background-color', 'transform']);

  if (!matches) {
    return <></>;
  }

  const transitionOptions = {
    easing: theme.transitions.easing.easeInOut,
    duration: theme.transitions.duration.enteringScreen,
  };

  return (
    <Box>
      <TransitionGroup>
        <Paper
          variant="elevation"
          elevation={20}
          sx={{
            borderTopLeftRadius: 8,
            borderTopRightRadius: 8,
            borderBottomLeftRadius: 0,
            borderBottomRightRadius: 0,
            borderBottomWidth: 0,
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'flex-end',
            position: 'fixed',
            bottom: 0,
            right: 0,
            m: 0,
            mr: open ? 0 : 2,
            p: 0,
            maxHeight: open ? '50vh' : '150px',
            transition: theme.transitions.create(['max-width', 'max-height', 'margin-right'], transitionOptions),
          }}
        >
          <Box
            sx={{
              display: 'flex',
              justifyContent: 'flex-end',
              mr: open ? 2 : 0,
              transition: theme.transitions.create(['margin-right'], transitionOptions),
            }}
          >
            <Button
              variant="text"
              startIcon={open ? <ArrowDownIcon /> : <ArrowUpIcon />}
              onClick={() => setOpen(!open)}
              sx={{ m: 0.5 }}
              disableRipple
            >
              {open ? 'Log verbergen' : 'Log anzeigen'}
            </Button>
          </Box>
          <Box
            height={open ? '14em' : 0}
            width={open ? 'calc(100vw)' : 0}
            sx={{
              overflow: 'auto',
              px: open ? 1 : 0,
              transition: theme.transitions.create(['width', 'height'], transitionOptions),
            }}
          >
            {open && <Divider sx={{ mb: 1 }} />}
            {open && <LogLinesView />}
          </Box>
        </Paper>
      </TransitionGroup>
    </Box>
  );
}

export default LogView;
