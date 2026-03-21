import MyTransitLineCard, {
  TransitLineCardProps as MyTransitLineCardProps,
} from '../../../mod/lines/TransitLineCard';
import { Box } from '@mui/material';
import { BrowserRouter } from 'react-router-dom';

export type TransitLineCardProps = Omit<MyTransitLineCardProps, 'children'>;

export const TransitLineCard = ({ ...rest }: TransitLineCardProps) => (
  <BrowserRouter>
    <MyTransitLineCard {...rest}>
      <Box p={2}>Hello World</Box>
    </MyTransitLineCard>
  </BrowserRouter>
);
