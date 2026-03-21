import MyOldTransitLineCard, {
  OldTransitLineCardProps as MyOldTransitLineCardProps,
} from '../../../mod/lines/OldTransitLineCard';
import { Box } from '@mui/material';
import { BrowserRouter } from 'react-router-dom';

export type OldTransitLineCardProps = Omit<MyOldTransitLineCardProps, 'children'>;

export const OldTransitLineCard = ({ ...rest }: OldTransitLineCardProps) => (
  <BrowserRouter>
    <MyOldTransitLineCard {...rest}>
      <Box p={2}>Hello World</Box>
    </MyOldTransitLineCard>
  </BrowserRouter>
);
