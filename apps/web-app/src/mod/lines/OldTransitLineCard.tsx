import { lazy } from 'react';
const AppCardBg = lazy(() => import('../../ui/AppCardBg'));
import TransitLineSegment from './TransitLineSegment';
import Line from './model/Line';
import BusIcon from '@mui/icons-material/DirectionsBus';
import TramIcon from '@mui/icons-material/Tram';
import Chip from '@mui/material/Chip';
import Grid from '@mui/material/Grid';
import { styled } from '@mui/material/styles';
import { useState } from 'react';

export interface OldTransitLineCardProps {
  line: Line;
}

const OldTransitLineCard = (props: OldTransitLineCardProps) => {
  const line = props.line;
  const [expanded, setExpanded] = useState(false);

  const Pre = styled('pre')({
    fontSize: 14,
    whiteSpace: 'normal',
  });

  return (
    <AppCardBg
      title={`Linie ${line.id}`}
      image="/assets/card-img-traffic.jpg"
      // to={`/transit/${i.id}`}
      additionalChips={line.lineSegments.map((el) => (
        <Chip key={el.destination} variant="outlined" label={el.destination} icon={getIcon(line.trafficType)} />
      ))}
      expanded={expanded}
      setExpanded={setExpanded}
    >
      {expanded && (
        <Grid container sx={{ width: 1 }}>
          {line.lineSegments.map((ls) => (
            <Grid size={{ xs: 6 }}>
              <TransitLineSegment segment={ls} />
            </Grid>
          ))}
        </Grid>
      )}
    </AppCardBg>
  );
};

function getIcon(trafficType: string) {
  switch (trafficType) {
    default:
    case 'BUS':
      return <BusIcon />;
    case 'TRAM':
      return <TramIcon />;
  }
}

export default OldTransitLineCard;
