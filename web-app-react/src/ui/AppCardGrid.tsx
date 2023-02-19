import Grid from '@mui/material/Unstable_Grid2';
import { Key, ReactNode } from 'react';

function AppCardGrid(props: { reactKey?: Key; children: ReactNode }) {
  return (
    <Grid xs={12} sm={6} md={4} lg={3} key={props.reactKey}>
      {props.children}
    </Grid>
  );
}

export default AppCardGrid;
