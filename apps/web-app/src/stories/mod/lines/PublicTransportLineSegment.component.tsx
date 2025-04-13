import MyPublicTransportLineSegment, {
  PublicTransportLineSegmentProps as MyPublicTransportLineSegmentProps,
} from '../../../mod/lines/PublicTransportLineSegment';
import { Box } from '@mui/material';
import { BrowserRouter } from 'react-router-dom';

export type PublicTransportLineSegmentProps = Omit<MyPublicTransportLineSegmentProps, 'children'>;

export const PublicTransportLineSegment = ({ ...rest }: PublicTransportLineSegmentProps) => (
  <BrowserRouter>
    <MyPublicTransportLineSegment {...rest}>
      <Box p={2}>Hello World</Box>
    </MyPublicTransportLineSegment>
  </BrowserRouter>
);
