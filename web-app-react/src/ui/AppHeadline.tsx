import Typography from '@mui/material/Typography';
import { ReactNode } from 'react';

function AppPageHeadline(props: { children: ReactNode; gutterTop?: boolean; gutterBottom?: boolean }) {
  return (
    <Typography variant="h5" gutterBottom={props.gutterBottom} sx={{ pt: props.gutterTop ? 5 : 0 }}>
      {props.children}
    </Typography>
  );
}

export default AppPageHeadline;
