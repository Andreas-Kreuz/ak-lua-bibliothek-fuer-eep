import Grid from '@mui/material/Grid';
import { Key, ReactNode } from 'react';

function AppCardGrid(props: { reactKey?: Key; children: ReactNode }) {
  return (
    <Grid
      size={{ xs: 12, sm: 6, md: 4, lg: 3 }}
      container
      key={props.reactKey}
      sx={{ flexDirection: 'column', alignItems: 'stretch' }}
    >
      {props.children}
    </Grid>
  );
}

export default AppCardGrid;
