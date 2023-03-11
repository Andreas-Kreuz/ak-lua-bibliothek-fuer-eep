import { useSocket } from '../io/SocketProvider';
import { CommandEvent, LuaSetting } from '@ak/web-shared';
import { FormLabel, FormGroup, FormControlLabel, Switch, FormHelperText } from '@mui/material';
import FormControl from '@mui/material/FormControl';
import Typography from '@mui/material/Typography';
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
      <FormGroup>
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
