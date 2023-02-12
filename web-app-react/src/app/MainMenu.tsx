import {
  Card,
  CardActionArea,
  CardContent,
  CardHeader,
  CardMedia,
  Typography,
  Unstable_Grid2 as Grid,
} from '@mui/material';
import React, { useState } from 'react';
import useNavState from './NavElements';

function MainMenu() {
  const navigation = useNavState();

  const trafficNav = navigation.filter((nav) => nav.name === 'Verkehr').flatMap((nav) => nav.values);
  const dataNav = navigation.filter((nav) => nav.name === 'Daten').flatMap((nav) => nav.values);
  console.log(trafficNav);

  return (
    <Grid container sx={{ p: 2, width: '100vw' }} spacing={2}>
      {trafficNav.map((card) => (
        <Grid xs={12} sm={6} lg={3} key={card.title}>
          <Card>
            <CardActionArea>
              {card.image ? <CardMedia image="{card.image}" title="green iguana" /> : ''}
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
