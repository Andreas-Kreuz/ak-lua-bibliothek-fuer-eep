import Stack from '@mui/material/Stack';
import Typography from '@mui/material/Typography';
import { ReactNode } from 'react';

function AppPageHeadline(props: { children: ReactNode; gutterTop?: boolean; rightSettings?: ReactNode }) {
  return (
    <Stack direction="row" sx={{ display: 'flex', alignContent: 'center', justifyContent: 'space-between' }}>
      <Typography variant="h4" gutterBottom color="text.secondary" sx={{ pt: props.gutterTop ? 10 : 0 }}>
        {props.children}
      </Typography>
      {props.rightSettings}
    </Stack>
  );
}

export default AppPageHeadline;
