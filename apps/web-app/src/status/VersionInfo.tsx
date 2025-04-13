import Chip from '@mui/material/Chip';
import Stack from '@mui/material/Stack';
import Typography from '@mui/material/Typography';
import useVersionStatus from './useVersionInfo';
import Grid from '@mui/material/Grid';

function VersionInfo() {
  const versions = useVersionStatus();

  return (
    <>
      <Grid container style={{ alignItems: 'center' }} justifyContent={'space-between'} mt={2} mb={2}>
        <Typography mr={2}>Versionen:</Typography>
        <Stack direction="row" justifyContent="flex-start" alignItems="center" spacing={2} mr={2}>
          <Chip label={'App ' + versions.appVersion} />
          <Chip label={'EEP ' + versions.eepVersion} />
          <Chip label={'Lua ' + versions.luaVersion} />
        </Stack>
      </Grid>
    </>
  );
}

export default VersionInfo;
