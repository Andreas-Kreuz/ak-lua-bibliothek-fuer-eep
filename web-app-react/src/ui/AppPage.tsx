import Box from '@mui/material/Box';
import { ReactNode } from 'react';

function AppPage(props: { children: ReactNode; gutterTop?: boolean }) {
  return <Box sx={{ m: { xs: 2, sm: 5 } }}>{props.children}</Box>;
}

export default AppPage;
