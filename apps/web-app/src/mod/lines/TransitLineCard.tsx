import TransitLineSegment from './TransitLineSegment';
import Line from './model/Line';

import Grid from '@mui/material/Grid';
import { styled } from '@mui/material/styles';
import { useState } from 'react';
import AkCard from '../../ui/AkCard';
import { Avatar, CardActionArea, Divider, Stack, Typography } from '@mui/material';
import { getColor, getIcon } from './Transit';

export interface TransitLineCardProps {
  line: Line;
  expanded?: boolean;
}

const TransitLineCard = (props: TransitLineCardProps) => {
  const [expanded, setExpanded] = useState(props.expanded);
  const line = props.line;

  const Pre = styled('pre')({
    fontSize: 14,
    whiteSpace: 'normal',
  });

  const handleExpand = () => {
    if (setExpanded) {
      setExpanded(!expanded);
    }
  };

  return (
    <AkCard>
      <CardActionArea onClick={handleExpand}>
        <Stack direction={'row'} pt={2} px={2} spacing={1}>
          <Avatar sx={{ bgcolor: getColor(line.trafficType) }}>{getIcon(line.trafficType)}</Avatar>
          <Typography variant="h5" fontWeight={500} px={2} minWidth={'4rem'} align="center">
            {line.nr}
          </Typography>
          <Typography variant="h5">{line.lineSegments.flatMap((el) => el.destination).join(' - ')}</Typography>
        </Stack>
        <Stack pb={(expanded && 0) || 2}></Stack>
        {expanded && (
          <>
            <Divider />
            <Grid container sx={{ width: 1 }}>
              {line.lineSegments.map((ls) => (
                <Grid size={{ xs: 12, md: 6 }}>
                  <TransitLineSegment segment={ls} />
                </Grid>
              ))}
            </Grid>
          </>
        )}
      </CardActionArea>
    </AkCard>
  );
};

export default TransitLineCard;
