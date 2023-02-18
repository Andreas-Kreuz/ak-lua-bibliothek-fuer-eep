import Typography from '@mui/material/Typography';
import { ReactNode } from 'react';

function TypeCaption(props: { children: ReactNode; gutterTop?: boolean }) {
  return (
    <Typography variant="caption" gutterBottom color="text.secondary" sx={{ pt: props.gutterTop ? 2 : 0 }}>
      {props.children}
    </Typography>
  );
}

export default TypeCaption;
