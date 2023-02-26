import Typography from '@mui/material/Typography';
import { ReactNode } from 'react';

function AppPageHeadline(props: { children: ReactNode; gutterTop?: boolean }) {
  return (
    <Typography variant="h4" gutterBottom color="text.secondary" sx={{ pt: props.gutterTop ? 10 : 0 }}>
      {props.children}
    </Typography>
  );
}

export default AppPageHeadline;
