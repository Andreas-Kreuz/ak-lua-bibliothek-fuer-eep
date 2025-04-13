import MyAkCard, { AkCardProps as MyAppCardProps } from '../../ui/AkCard';
import { Box } from '@mui/material';
import { BrowserRouter } from 'react-router-dom';

export type AkCardProps = Omit<MyAppCardProps, 'children'>;

export const AkCard = ({ ...rest }: AkCardProps) => (
  <BrowserRouter>
    <MyAkCard {...rest}>
      <Box p={2}>Hello World</Box>
    </MyAkCard>
  </BrowserRouter>
);
