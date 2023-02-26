import Chip from '@mui/material/Chip';
import Stack from '@mui/material/Stack';
import Typography from '@mui/material/Typography';
import useVersionStatus from './useVersionInfo';

function VersionInfo() {
  const [verApp, verEep, verLua] = useVersionStatus();

  return (
    <div>
      <Stack direction="row" justifyContent="flex-start" alignItems="center" spacing={2} m={2}>
        <Typography>Versionen:</Typography>
        <Chip label={'App ' + verApp} />
        <Chip label={'EEP ' + verEep} />
        <Chip label={'Lua ' + verLua} />
      </Stack>
    </div>
  );
}

export default VersionInfo;
