import AppCardBg from '../../ui/AppCardBg';
import TrainDetails, { getTrainChips } from './TrainDetails';
import { trainIconFor } from './trainIconFor';
import { TrainListEntry, TrainType } from '@ak/web-shared';
import Box from '@mui/material/Box';
import Collapse from '@mui/material/Collapse';
import Divider from '@mui/material/Divider';
import { useState } from 'react';

const getIconName = (trainType: TrainType): string => {
  const imgName = trainIconFor(trainType);
  return '/assets/' + imgName + '.svg';
};

const getImageName = (trackType: string): string => {
  switch (trackType) {
    case 'road':
      return '/assets/card-img-trains-road.jpg';
    case 'tram':
      return '/assets/card-img-trains-tram.jpg';
    case 'train':
    default:
      return '/assets/card-img-trains-rail.jpg';
  }
};

const TrainListEntryCard = (props: { train: TrainListEntry }) => {
  const [expanded, setExpanded] = useState(false);
  const t = props.train;
  const additionalChips = getTrainChips(t);
  return (
    <AppCardBg
      title={`Fahrzeug`}
      id={t.id}
      additionalChips={additionalChips}
      icon={getIconName(t.trainType)}
      image={getImageName(t.trackType)}
      //  to={`/train/${t.id}`}
      expanded={expanded}
      setExpanded={setExpanded}
    >
      {expanded && <Divider sx={{ width: 1 }} />}
      <Collapse in={expanded} mountOnEnter unmountOnExit sx={{ flexGrow: 1, width: 1 }}>
        <Box sx={{ flexGrow: 1, width: 1, p: 2 }}>
          <TrainDetails train={t} />
        </Box>
      </Collapse>
    </AppCardBg>
  );
};

export default TrainListEntryCard;
