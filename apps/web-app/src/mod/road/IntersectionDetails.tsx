import { lazy } from 'react';
const AppCaption = lazy(() => import('../../ui/AppCaption'));
const AppHeadline = lazy(() => import('../../ui/AppHeadline'));
const AppPage = lazy(() => import('../../ui/AppPage'));
const AppPaper = lazy(() => import('../../ui/AppPaper'));
import { useSocket } from '../../io/SocketProvider';
import useIntersection from './useIntersection';
import useIntersectionSwitching from './useIntersectionSwitching';
import { CommandEvent, RoadEvent } from '@ak/web-shared';
import CamIcon from '@mui/icons-material/Videocam';
import Alert from '@mui/material/Alert';
import Chip from '@mui/material/Chip';
import Divider from '@mui/material/Divider';
import Stack from '@mui/material/Stack';
import Typography from '@mui/material/Typography';
import { styled, useTheme } from '@mui/material/styles';
import { useParams } from 'react-router-dom';
import { Tooltip } from '@mui/material';

function IntersectionDetails() {
  const theme = useTheme();
  const socket = useSocket();
  const { intersectionId } = useParams();
  const id = parseInt(intersectionId || '555');
  const i = useIntersection(id);
  const switchings = useIntersectionSwitching(i?.name);

  const Pre = styled('pre')({
    fontSize: 14,
    whiteSpace: 'normal',
  });

  function sendSwitchManually(intersectionName: string, switchingName: string) {
    socket.emit(RoadEvent.SwitchManually, {
      intersectionName,
      switchingName,
    });
  }

  function sendSwitchAutomatically(intersectionName: string) {
    socket.emit(RoadEvent.SwitchAutomatically, {
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
            <AppHeadline gutterBottom>Kreuzung {i.id}</AppHeadline>
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
            {i.staticCams && i.staticCams.length > 0 && (
              <>
                <Divider sx={{ py: 1 }} />
                <AppCaption gutterTop>Kameras</AppCaption>
                <Stack direction="row" pt={1} pb={0}>
                  {i.staticCams.map((c, j) => {
                    return (
                      <Tooltip title={c}>
                        <Chip
                          sx={{
                            mr: 1,
                            mb: 1,
                            justifyContent: 'flex-start',
                          }}
                          color={'secondary'}
                          icon={<CamIcon />}
                          label={(i.staticCams.length === 1 && c) || j}
                          variant={'outlined'}
                          key={c}
                          clickable
                          onClick={() => {
                            changeCam(c);
                          }}
                        ></Chip>
                      </Tooltip>
                    );
                  }) || 'Keine'}
                </Stack>
              </>
            )}
          </AppPaper>

          {i.staticCams && i.staticCams.length === 0 && (
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
