import useVersionStatus from './useVersionInfo';
import VersionInfo from './VersionInfo';

function VersionInfoWrapper() {
  const versions = useVersionStatus();

  return (
    <VersionInfo appVersion={versions.appVersion} eepVersion={versions.eepVersion} luaVersion={versions.luaVersion} />
  );
}

export default VersionInfoWrapper;
