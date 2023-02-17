import Grid from '@mui/material/Unstable_Grid2';
import { Key, ReactNode } from 'react';

function AppCardGridContainer(props: { key?: Key; children: ReactNode }) {
  return (
    <Grid container spacing={{ xs: 2, md: 5 }}>
      {props.children}
    </Grid>
  );
}

export default AppCardGridContainer;
