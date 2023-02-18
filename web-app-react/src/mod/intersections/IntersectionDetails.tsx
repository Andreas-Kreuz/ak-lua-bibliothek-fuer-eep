import AppPage from '../../ui/AppPage';
import Stack from '@mui/material/Stack';
import Chip from '@mui/material/Chip';
import useIntersection from './useIntersection';
import useIntersectionSwitching from './useIntersectionSwitching';
import { useMatches } from 'react-router-dom';
import AppPaper from '../../ui/AppPaper';
import AppHeadline from '../../ui/AppHeadline';
import AppBackButton from '../../ui/AppBackButton';
import { useContext } from 'react';
import { SocketContext } from '../../base/SocketProvidedApp';
import { CommandEvent, IntersectionEvent } from 'web-shared';
import Divider from '@mui/material/Divider';
import { useTheme } from '@mui/material/styles';
import AppCaption from '../../ui/AppCaption';
import Typography from '@mui/material/Typography/Typography';
import Alert from '@mui/material/Alert';
import styled from '@mui/system/styled';

function IntersectionDetails() {
  const theme = useTheme();
  const socket = useContext(SocketContext);
  const matches = useMatches();
  const id = parseInt(matches[0].params.intersectionId || '555');
  const i = useIntersection(id);
  const switchings = useIntersectionSwitching(i?.name);

  const Pre = styled('pre')({
    fontSize: 14,
    whiteSpace: 'normal',
  });

  function sendSwitchManually(intersectionName: string, switchingName: string) {
    socket.emit(IntersectionEvent.SwitchManually, {
      intersectionName,
      switchingName,
    });
  }

  function sendSwitchAutomatically(intersectionName: string) {
    socket.emit(IntersectionEvent.SwitchAutomatically, {
      intersectionName,
    });
  }

  function changeCam(camName: string) {
    socket.emit(CommandEvent.ChangeCamToStatic, { staticCam: camName });
  }

  return (
    <AppPage>
      {i && (
        <>
          <AppPaper
          // image="/assets/card-img-intersection.jpg"
          >
            <AppHeadline gutterBottom>
              <AppBackButton to="/intersections" /> Kreuzung {i.id}
            </AppHeadline>
            <Chip label={i.name} />
            <Stack
              direction="row"
              sx={{ alignItems: 'center', justifyContent: 'space-between', flexWrap: 'wrap' }}
            ></Stack>
            <AppCaption gutterTop>Modus</AppCaption>
            <Stack direction="row" spacing={1}>
              <Chip
                label="Auto"
                variant="filled"
                color={i.manualSwitching ? 'default' : 'primary'}
                onClick={() => {
                  sendSwitchAutomatically(i.name);
                }}
              />
              <Chip
                label="Manuell"
                variant="filled"
                color={i.manualSwitching ? 'primary' : 'default'}
                onClick={() => {
                  sendSwitchManually(i.name, i.currentSwitching);
                }}
              />
            </Stack>

            <Divider sx={{ py: 1 }} />
            <AppCaption gutterTop>Schaltung</AppCaption>
            <Stack
              direction="row"
              flexWrap="wrap"
              pt={1}
              pb={0}
              // sx={{ backgroundColor: theme.palette.background.default }}
            >
              {switchings.map((s) => {
                const active = i.currentSwitching === s.name;
                const next =
                  (i.nextSwitching === s.name || i.manualSwitching === s.name) && i.currentSwitching !== s.name;
                const color = active ? 'primary' : next ? 'primary' : 'default';
                const clickable = i.manualSwitching ? true : false;
                return (
                  <Chip
                    sx={{
                      mr: 1,
                      mb: 1,
                      color: active || next ? theme.palette.primary.contrastText : undefined,
                      backgroundColor: active || next ? theme.palette.primary.main : clickable ? undefined : 'white',
                    }}
                    label={s.name}
                    variant={i.manualSwitching ? 'filled' : 'outlined'}
                    key={s.name}
                    color={color}
                    clickable={clickable}
                    disabled={!active && (!clickable || next)}
                    onClick={() => {
                      if (clickable) sendSwitchManually(i.name, s.name);
                    }}
                  ></Chip>
                );
              })}
            </Stack>

            <Divider sx={{ py: 1 }} />
            <AppCaption gutterTop>Kameras</AppCaption>
            <Stack
              direction="row"
              flexWrap="wrap"
              pt={1}
              pb={0}
              // sx={{ backgroundColor: theme.palette.background.default }}
            >
              {(i.staticCams &&
                i.staticCams.length > 0 &&
                i.staticCams.map((c) => {
                  return (
                    <Chip
                      sx={{
                        mr: 1,
                        mb: 1,
                      }}
                      label={c}
                      variant={'filled'}
                      key={c}
                      clickable
                      onClick={() => {
                        changeCam(c);
                      }}
                    ></Chip>
                  );
                })) ||
                'Keine'}
            </Stack>
          </AppPaper>

          {i.staticCams && i.staticCams.length == 0 && (
            <Alert
              severity="info"
              sx={{
                border: 1,
                borderColor: 'info.main',
                alignItems: 'top',
                mt: 2,
              }}
              icon={false}
            >
              <Typography variant="body2" sx={{ fontWeight: 'bolder' }} gutterBottom>
                Tipp: Kameras hinzufügen
              </Typography>
              <Typography variant="body2">
                So hast Du Deine Kreuzung angelegt:
                <Pre>c1 = Crossing:new(...)</Pre>
                Suche Dir nun eine statische Kamera aus und füge ihren Namen wie folgt hinzu:
                <Pre>c1:addStaticCam('Kameraname')</Pre>
              </Typography>
            </Alert>
          )}
        </>
      )}
    </AppPage>
  );
}

export default IntersectionDetails;
