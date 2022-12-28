import { Card, Stack } from '@mui/material';

function VersionInfo() {
  return (
    <div>
      <Stack sx={{ m: 5 }} spacing={2}>
        <Card sx={{ p: 3 }}>EEP-Web: Nicht verbunden</Card>
        <Card sx={{ p: 3 }}>EEP-Lua: Nicht verbunden</Card>
        <Card sx={{ p: 3 }}>EEP: Nicht verbunden</Card>
      </Stack>
    </div>
  );
}

export default VersionInfo;
