import Paper from '@mui/material/Paper';
import ArrowUpIcon from '@mui/icons-material/KeyboardArrowUp';
import ArrowDownIcon from '@mui/icons-material/KeyboardArrowDown';
import DeleteIcon from '@mui/icons-material/Delete';
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import Divider from '@mui/material/Divider';
import Typography from '@mui/material/Typography';
import useMediaQuery from '@mui/material/useMediaQuery';
import { useTheme } from '@mui/material/styles';
import { useContext, useState } from 'react';
import { LogEvent } from 'web-shared';
import { useSocket } from '../../io/SocketProvider';
import LogLines from './LogLines';
import FormControlLabel from '@mui/material/FormControlLabel';
import Switch from '@mui/material/Switch';
import { useLog, useLogDispatch } from './LogProvider';

function LogPanel() {
  const socket = useSocket();
  const theme = useTheme();
  const matches = useMediaQuery(theme.breakpoints.up('md'));
  const [open, setOpen] = useState(false);
  const logState = useLog();
  const autoScroll = logState?.autoScroll;
  const logDispatch = useLogDispatch();

  const setAutoScroll = (autoScroll: boolean) => {
    logDispatch && logDispatch({ type: 'setAutoScroll', autoScroll: autoScroll });
  };

  function clearLog() {
    socket.emit(LogEvent.ClearLog);
  }

  const transitionOptions = {
    easing: theme.transitions.easing.easeInOut,
    duration: theme.transitions.duration.enteringScreen,
  };

  const innerBox = (
    <Box>
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
          maxHeight: open ? 'calc(100vh - 60px)' : '150px',
          transition: theme.transitions.create(['max-width', 'max-height', 'margin-right'], transitionOptions),
        }}
      >
        <Box
          sx={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'flex-end',
            mr: open ? 2 : 0,
            transition: theme.transitions.create(['margin-right'], transitionOptions),
          }}
        >
          {open && (
            <>
              <Typography variant="body1" sx={{ px: 1, py: 0.5 }}>
                EEP Log
              </Typography>

              <Box sx={{ flexGrow: 1 }} />
              <FormControlLabel
                value="end"
                control={<Switch color="primary" checked={autoScroll} onChange={() => setAutoScroll(!autoScroll)} />}
                label="Log folgen"
                labelPlacement="end"
              />
              <Divider orientation="vertical" variant="middle" flexItem />
              <Button
                id="delete-log"
                variant="text"
                startIcon={<DeleteIcon />}
                onClick={() => {
                  clearLog();
                }}
                sx={{ m: 0.5 }}
                disableRipple
              >
                Log löschen
              </Button>
              <Divider orientation="vertical" variant="middle" flexItem />
            </>
          )}
          <Button
            id="open-log"
            variant="text"
            startIcon={open ? <ArrowDownIcon /> : <ArrowUpIcon />}
            onClick={() => setOpen(!open)}
            sx={{ m: 0.5 }}
            disableRipple
          >
            {open ? 'Log verbergen' : 'Log anzeigen'}
          </Button>
        </Box>
        {open && <Divider />}
        <Box
          height={open ? '14.2em' : 0}
          width={open ? 'calc(100vw)' : 0}
          sx={{
            pt: 0,
            px: 0,
            transition: theme.transitions.create(['width', 'height'], transitionOptions),
          }}
        >
          {open && <LogLines />}
        </Box>
      </Paper>
    </Box>
  );

  return <>{matches && innerBox}</>;
}

export default LogPanel;
