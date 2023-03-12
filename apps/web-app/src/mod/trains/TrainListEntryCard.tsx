import AppCardBg from '../../ui/AppCardBg';
import TrainCamList from './TrainCamList';
import { trainIconFor } from './trainIconFor';
import { TrainListEntry, TrainType } from '@ak/web-shared';
import Chip from '@mui/material/Chip';
import Divider from '@mui/material/Divider';

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
  const t = props.train;
  return (
    <AppCardBg
      title={`Fahrzeug`}
      id={t.id}
      icon={getIconName(t.trainType)}
      image={getImageName(t.trackType)}
      //  to={`/train/${t.id}`}
    >
      <Chip variant="filled" label={t.trainType} />
      <Chip variant="filled" label={t.route} />
      <Chip variant="filled" label={t.line} />
      <Chip variant="filled" label={t.destination} />
      <Chip variant="filled" label={t.id} />
      <Chip variant="filled" label={t.name} />
      <Chip variant="filled" label={t.trackType} />
      <Chip variant="filled" label={t.trainType} />
      <Divider sx={{ my: 1 }} />
      <TrainCamList trainName={t.id} />
    </AppCardBg>
  );
};

export default TrainListEntryCard;
