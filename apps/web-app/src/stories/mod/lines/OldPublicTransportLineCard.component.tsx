import MyOldPublicTransportLineCard, {
  OldPublicTransportLineCardProps as MyOldPublicTransportLineCardProps,
} from '../../../mod/lines/OldPublicTransportLineCard';
import { Box } from '@mui/material';
import { BrowserRouter } from 'react-router-dom';

export type OldPublicTransportLineCardProps = Omit<MyOldPublicTransportLineCardProps, 'children'>;

export const OldPublicTransportLineCard = ({ ...rest }: OldPublicTransportLineCardProps) => (
  <BrowserRouter>
    <MyOldPublicTransportLineCard {...rest}>
      <Box p={2}>Hello World</Box>
    </MyOldPublicTransportLineCard>
  </BrowserRouter>
);
