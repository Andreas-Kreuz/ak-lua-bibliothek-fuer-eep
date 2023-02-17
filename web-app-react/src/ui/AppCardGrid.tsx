import Grid from '@mui/material/Unstable_Grid2';
import { Key, ReactNode } from 'react';

function AppCardGrid(props: { key?: Key; children: ReactNode }) {
  return (
    <Grid xs={12} md={6} xl={3} key={props.key}>
      {props.children}
    </Grid>
  );
}

export default AppCardGrid;
