import MyPublicTransportLineCard, {
  PublicTransportLineCardProps as MyPublicTransportLineCardProps,
} from '../../../mod/lines/PublicTransportLineCard';
import { Box } from '@mui/material';
import { BrowserRouter } from 'react-router-dom';

export type PublicTransportLineCardProps = Omit<MyPublicTransportLineCardProps, 'children'>;

export const PublicTransportLineCard = ({ ...rest }: PublicTransportLineCardProps) => (
  <BrowserRouter>
    <MyPublicTransportLineCard {...rest}>
      <Box p={2}>Hello World</Box>
    </MyPublicTransportLineCard>
  </BrowserRouter>
);
