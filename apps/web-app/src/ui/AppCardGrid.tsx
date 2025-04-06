import Grid from '@mui/material/Grid';
import { Key, ReactNode } from 'react';

function AppCardGrid(props: { reactKey?: Key; children: ReactNode }) {
  return (
    <Grid container sx={{ display: 'flex', flexGrow: 1 }} size={{ xs: 12, sm: 6, md: 4, lg: 3 }} key={props.reactKey}>
      {props.children}
    </Grid>
  );
}

export default AppCardGrid;
