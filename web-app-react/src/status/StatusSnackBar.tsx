import { Alert, Snackbar } from '@mui/material';
import { useEffect, useState } from 'react';
import { useServerStatus } from '../server-io/ServerStatusEffectHook';
import CheckCircleOutlineRoundedIcon from '@mui/icons-material/CheckCircleOutlineRounded';
import RunningWithErrorsRoundedIcon from '@mui/icons-material/RunningWithErrorsRounded';

export interface SnackbarMessage {
  message: string;
  severity: 'warning' | 'success';
  key: number;
}

export interface State {
  open: boolean;
  snackPack: readonly SnackbarMessage[];
  messageInfo?: SnackbarMessage;
}

function StatusSnackBar() {
  const [lastEepUpToDate, setLastEepUpToDate] = useState(false);
  const [isConnected, eepDataUpToDate, luaDataReceived, apiEntryCount] = useServerStatus();
  const [open, setOpen] = useState(false);
  const [messageInfo, setMessageInfo] = useState<SnackbarMessage | undefined>(undefined);
  const [snackPack, setSnackPack] = useState<readonly SnackbarMessage[]>([]);

  useEffect(() => {
    if (snackPack.length && !messageInfo) {
      // Set a new snack, when there is no message displayed
      setMessageInfo({ ...snackPack[0] });
      setSnackPack((prev) => prev.slice(1));
      setOpen(true);
    } else if (snackPack.length && messageInfo && open) {
      // Close an active snack, when a new one is added
      setOpen(false);
    }
  }, [snackPack, messageInfo, open]);

  useEffect(() => {
    if (!lastEepUpToDate && eepDataUpToDate) {
      setSnackPack((prev) => [
        ...prev,
        { message: 'EEP sendet Daten', severity: 'success', key: new Date().getTime() },
      ]);
    } else if (lastEepUpToDate && !eepDataUpToDate) {
      setSnackPack((prev) => [
        ...prev,
        { message: 'EEP wurde pausiert', severity: 'warning', key: new Date().getTime() },
      ]);
    }
    setLastEepUpToDate(eepDataUpToDate);
  });

  const handleClose = () => {
    setOpen(false);
  };

  const handleExited = () => {
    setMessageInfo(undefined);
  };

  return (
    <div>
      <Snackbar
        key={messageInfo ? messageInfo.key : undefined}
        open={open}
        autoHideDuration={2000}
        onClose={handleClose}
        TransitionProps={{ onExited: handleExited }}
      >
        <Alert
          sx={{ width: '100%' }}
          variant="filled"
          severity={messageInfo ? messageInfo.severity : 'info'}
          iconMapping={{
            success: <CheckCircleOutlineRoundedIcon fontSize="inherit" />,
            warning: <RunningWithErrorsRoundedIcon fontSize="inherit" />,
          }}
        >
          {messageInfo ? messageInfo.message : undefined}
        </Alert>
      </Snackbar>
    </div>
  );
}

export default StatusSnackBar;
