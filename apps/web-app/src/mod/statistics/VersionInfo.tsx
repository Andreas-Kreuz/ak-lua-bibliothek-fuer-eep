import MuiChip from '@mui/material/Chip';
import MuiStack from '@mui/material/Stack';
import MuiTypography from '@mui/material/Typography';
import Versions from './Versions';

export interface VersionInfoProps extends Versions {}

const VersionInfo = (props: VersionInfoProps) => {
  return (
    <MuiStack direction="row" justifyContent="flex-start" alignItems="center" flexWrap={'wrap'}>
      <MuiTypography pr={2}>Versionen:</MuiTypography>
      <MuiStack direction="row" justifyContent="flex-start" alignItems="center" spacing={2}>
        <MuiChip label={'App ' + props.appVersion} />
        <MuiChip label={'EEP ' + props.eepVersion} />
        <MuiChip label={'Lua ' + props.luaVersion} />
      </MuiStack>
    </MuiStack>
  );
};

export default VersionInfo;
