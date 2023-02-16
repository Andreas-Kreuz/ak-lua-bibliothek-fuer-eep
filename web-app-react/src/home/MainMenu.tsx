import Card from '@mui/material/Card';
import CardActionArea from '@mui/material/CardActionArea';
import CardHeader from '@mui/material/CardHeader';
import CardMedia from '@mui/material/CardMedia';
import Stack from '@mui/material/Stack';
import Grid from '@mui/material/Unstable_Grid2';
import useNavState from '../nav/NavElements';
import { Link as RouterLink } from 'react-router-dom';
import VersionInfo from '../status/VersionInfo';

function MainMenu() {
  const navigation = useNavState();

  const trafficNav = navigation.filter((nav) => nav.name === 'Verkehr').flatMap((nav) => nav.values);
  const dataNav = navigation.filter((nav) => nav.name === 'Daten').flatMap((nav) => nav.values);
  console.log(trafficNav[0].image);

  return (
    <>
      <Grid container sx={{ p: 2, width: '100vw' }} spacing={2}>
        {trafficNav.map((card) => (
          <Grid xs={12} sm={6} lg={3} key={card.title}>
            <Card>
              <CardActionArea component={RouterLink} to={card.link}>
                <Stack sx={{ flexDirection: { xs: 'row', sm: 'column' } }}>
                  {card.image ? (
                    <CardMedia
                      component="img"
                      image={'/assets/' + card.image}
                      title={card.title}
                      sx={{ width: { xs: '25%', sm: 1 } }}
                    />
                  ) : (
                    ''
                  )}
                  <CardHeader title={card.title} subheader={card.subtitle}></CardHeader>
                </Stack>
                {/* <CardContent>Hallo Echo</CardContent> */}
              </CardActionArea>
            </Card>
          </Grid>
        ))}
      </Grid>
      <VersionInfo />
    </>
  );
}

export default MainMenu;
