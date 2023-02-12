import Card from '@mui/material/Card';
import CardActionArea from '@mui/material/CardActionArea';
import CardContent from '@mui/material/CardContent';
import CardHeader from '@mui/material/CardHeader';
import CardMedia from '@mui/material/CardMedia';
import Grid from '@mui/material/Unstable_Grid2';
import useNavState from './NavElements';

function MainMenu() {
  const navigation = useNavState();

  const trafficNav = navigation.filter((nav) => nav.name === 'Verkehr').flatMap((nav) => nav.values);
  const dataNav = navigation.filter((nav) => nav.name === 'Daten').flatMap((nav) => nav.values);
  console.log(trafficNav[0].image);

  return (
    <Grid container sx={{ p: 2, width: '100vw' }} spacing={2}>
      {trafficNav.map((card) => (
        <Grid xs={12} sm={6} lg={3} key={card.title}>
          <Card elevation={3}>
            <CardActionArea>
              {card.image ? <CardMedia component="img" image={'/assets/' + card.image} title="green iguana" /> : ''}
              <CardHeader title={card.title} subheader={card.subtitle}></CardHeader>
              <CardContent>Hallo Echo</CardContent>
            </CardActionArea>
          </Card>
        </Grid>
      ))}
    </Grid>
  );
}

export default MainMenu;
