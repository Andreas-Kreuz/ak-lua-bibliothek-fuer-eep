import ModuleSettings from './ModuleSettings';
import { LuaSettings } from '@ak/web-shared';
import CloseIcon from '@mui/icons-material/CloseOutlined';
import TuneIcon from '@mui/icons-material/TuneOutlined';
import AppBar from '@mui/material/AppBar';
import Button from '@mui/material/Button';
import Dialog from '@mui/material/Dialog';
import IconButton from '@mui/material/IconButton';
import Slide from '@mui/material/Slide';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import { TransitionProps } from '@mui/material/transitions';
import { forwardRef, ReactElement, Ref, useState } from 'react';

const Transition = forwardRef(function Transition(
  props: TransitionProps & {
    children: ReactElement;
  },
  ref: Ref<unknown>
) {
  return <Slide direction="up" ref={ref} {...props} />;
});

function ModuleSettingsButton(props: { settings?: LuaSettings }) {
  const [open, setOpen] = useState(false);

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  if (!props.settings) {
    return <></>;
  }

  return (
    <div>
      <Button variant="outlined" startIcon={<TuneIcon />} onClick={handleClickOpen}>
        Einstellungen
      </Button>
      <Dialog fullScreen open={open} onClose={handleClose} TransitionComponent={Transition}>
        <AppBar sx={{ position: 'relative' }}>
          <Toolbar>
            <IconButton edge="start" color="inherit" onClick={handleClose} aria-label="close">
              <CloseIcon />
            </IconButton>
            <Typography sx={{ ml: 2, flex: 1 }} variant="h6" component="div">
              {props.settings.moduleName}
            </Typography>
          </Toolbar>
        </AppBar>
        <ModuleSettings settings={props.settings} />
      </Dialog>
    </div>
  );
}

export default ModuleSettingsButton;
