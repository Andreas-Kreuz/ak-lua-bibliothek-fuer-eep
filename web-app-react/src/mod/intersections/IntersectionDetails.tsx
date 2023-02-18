import AppPageHeadline from '../../ui/AppPageHeadline';
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
import { IntersectionEvent } from 'web-shared';
import Divider from '@mui/material/Divider';
import { useTheme } from '@mui/material/styles';
import AppCaption from '../../ui/AppCaption';

function IntersectionDetails() {
  const theme = useTheme();
  const socket = useContext(SocketContext);
  const matches = useMatches();
  const id = parseInt(matches[0].params.intersectionId || '555');
  const i = useIntersection(id);
  const switchings = useIntersectionSwitching(i?.name);

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

  return (
    <AppPage>
      {i && (
        <>
          <AppPageHeadline>
            <AppBackButton to="/intersections" /> Kreuzung {i.id}
          </AppPageHeadline>
          <AppPaper
          // image="/assets/card-img-intersection.jpg"
          >
            <AppHeadline gutterBottom>Name</AppHeadline>
            <Chip label={i.name} />

            <Divider sx={{ my: 3 }} />

            <Stack direction="row" sx={{ alignItems: 'center', justifyContent: 'space-between', flexWrap: 'wrap' }}>
              <AppHeadline>Schaltungen</AppHeadline>
            </Stack>
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
          </AppPaper>
        </>
      )}
    </AppPage>
  );
}

export default IntersectionDetails;
