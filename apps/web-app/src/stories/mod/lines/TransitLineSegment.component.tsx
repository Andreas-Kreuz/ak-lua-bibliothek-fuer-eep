import MyTransitLineSegment, {
  TransitLineSegmentProps as MyTransitLineSegmentProps,
} from '../../../mod/lines/TransitLineSegment';
import { Box } from '@mui/material';
import { BrowserRouter } from 'react-router-dom';

export type TransitLineSegmentProps = Omit<MyTransitLineSegmentProps, 'children'>;

export const TransitLineSegment = ({ ...rest }: TransitLineSegmentProps) => (
  <BrowserRouter>
    <MyTransitLineSegment {...rest}>
      <Box p={2}>Hello World</Box>
    </MyTransitLineSegment>
  </BrowserRouter>
);
