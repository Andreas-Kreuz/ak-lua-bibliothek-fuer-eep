import { useSocket } from '../io/SocketProvider';
import { CommandEvent, LuaSetting } from '@ak/web-shared';
import { FormGroup, FormControlLabel, Switch, FormHelperText } from '@mui/material';
import { useState } from 'react';

const ModuleSetting = (props: { setting: LuaSetting<boolean> }) => {
  const socket = useSocket();
  const [checked, setChecked] = useState(props.setting.value);
  const handleChange = () => {
    const wasChecked = checked;
    setChecked(!checked);
    socket.emit(CommandEvent.ChangeSetting, {
      name: props.setting.name,
      func: props.setting.eepFunction,
      newValue: !wasChecked,
    });
  };

  return (
    <>
      <FormGroup sx={{ pt: 2 }}>
        <FormControlLabel
          control={<Switch checked={checked} onClick={handleChange} name={props.setting.name} />}
          label={props.setting.name}
        />
        <FormHelperText sx={{ mt: -1, ml: 6 }}>{props.setting.description}</FormHelperText>
      </FormGroup>
    </>
  );
};

export default ModuleSetting;
