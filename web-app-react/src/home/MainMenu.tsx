import Card from '@mui/material/Card';
import CardActionArea from '@mui/material/CardActionArea';
import CardHeader from '@mui/material/CardHeader';
import CardMedia from '@mui/material/CardMedia';
import Stack from '@mui/material/Stack';
import Grid from '@mui/material/Unstable_Grid2';
import useNavState from '../nav/NavElements';
import { Link as RouterLink } from 'react-router-dom';
import VersionInfo from '../status/VersionInfo';
import AppCardGrid from '../ui/AppCardGrid';
import AppCardImg from '../ui/AppCardImg';

function MainMenu() {
  const navigation = useNavState();

  const trafficNav = navigation.filter((nav) => nav.name === 'Verkehr').flatMap((nav) => nav.values);
  const dataNav = navigation.filter((nav) => nav.name === 'Daten').flatMap((nav) => nav.values);
  console.log(trafficNav[0].image);

  return (
    <>
      <Grid container sx={{ p: 2, width: '100vw' }} spacing={2}>
        {trafficNav.map((card) => (
          <AppCardGrid key={card.title}>
            <AppCardImg title={card.title} subtitle={card.subtitle} image={'/assets/' + card.image} to={card.link} />
          </AppCardGrid>
        ))}
      </Grid>
      <VersionInfo />
    </>
  );
}

export default MainMenu;
