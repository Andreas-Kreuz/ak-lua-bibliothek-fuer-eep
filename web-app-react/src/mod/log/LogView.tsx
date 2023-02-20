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
import { useCallback, useContext, useEffect, useRef, useState } from 'react';
import { LogEvent, RoomEvent } from 'web-shared';
import { SocketContext } from '../../base/SocketProvidedApp';
import LogLinesView from './LogLinesView';
import FormControlLabel from '@mui/material/FormControlLabel';
import Switch from '@mui/material/Switch';

function LogView() {
  const socket = useContext(SocketContext);
  const theme = useTheme();
  const matches = useMediaQuery(theme.breakpoints.up('md'));
  const [open, setOpen] = useState(true);
  const [autoScroll, setAutoScroll] = useState(true);
  const scrollTopRef = useRef(-1);
  const listRef = useRef<HTMLUListElement>();

  const onScroll = () => {
    const scrollY = window.scrollY;
    // console.log(`onScroll, window.scrollY: ${scrollY} listRef.scrollTop: ${listRef.current?.scrollTop}`);
    if (listRef.current) {
      if (listRef.current.scrollTop < scrollTopRef.current) {
        setAutoScroll(false);
      }
      scrollTopRef.current = listRef.current.scrollTop;
    }
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
          ref={listRef}
          height={open ? '14.2em' : 0}
          width={open ? 'calc(100vw)' : 0}
          onScroll={onScroll}
          sx={{
            overflow: 'auto',
            pt: open ? 1 : 0,
            px: open ? 1 : 0,
            transition: theme.transitions.create(['width', 'height'], transitionOptions),
          }}
        >
          {open && <LogLinesView autoScroll={autoScroll} />}
        </Box>
      </Paper>
    </Box>
  );

  return <>{matches && innerBox}</>;
}

export default LogView;
