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
import Switch from '@mui/material/Switch';
import FormControl from '@mui/material/FormControl';
import FormLabel from '@mui/material/FormLabel';
import FormGroup from '@mui/material/FormGroup';
import FormControlLabel from '@mui/material/FormControlLabel';
import { useContext } from 'react';
import { SocketContext } from '../../base/SocketProvidedApp';
import { IntersectionEvent } from 'web-shared';
import Divider from '@mui/material/Divider';
import { useTheme } from '@mui/material/styles';

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

            <Divider sx={{ mx: -1, my: 3 }} />

            <AppHeadline gutterBottom>Schaltungen</AppHeadline>
            <FormControl component="fieldset">
              <FormLabel component="legend">Automatik</FormLabel>
              <FormGroup aria-label="position" row>
                <FormControlLabel
                  value="end"
                  control={
                    <Switch
                      color="primary"
                      checked={!i.manualSwitching}
                      onClick={() => {
                        if (i.manualSwitching) {
                          sendSwitchAutomatically(i.name);
                        } else {
                          sendSwitchManually(i.name, i.currentSwitching);
                        }
                      }}
                    />
                  }
                  label="Automatisch schalten"
                  labelPlacement="end"
                />
              </FormGroup>
              <FormLabel component="legend" sx={{ pt: 2, pb: 1 }}>
                Nächste Schaltung
              </FormLabel>
              <FormGroup aria-label="position" row>
                <Stack direction="row" spacing={1} flexWrap="wrap">
                  {switchings.map((s) => {
                    const active = i.currentSwitching === s.name;
                    const next =
                      (i.nextSwitching === s.name || i.manualSwitching === s.name) && i.currentSwitching !== s.name;
                    const color = active ? 'primary' : next ? 'primary' : 'default';
                    const clickable = i.manualSwitching ? true : false;
                    return (
                      <Chip
                        sx={{
                          color: active || next ? theme.palette.background.default : undefined,
                          backgroundColor: active || next ? theme.palette.primary.main : undefined,
                        }}
                        label={s.name}
                        variant={i.manualSwitching ? 'filled' : 'outlined'}
                        key={s.name}
                        color={color}
                        clickable={clickable}
                        disabled={next}
                        onClick={() => {
                          if (clickable) sendSwitchManually(i.name, s.name);
                        }}
                      ></Chip>
                    );
                  })}
                </Stack>
              </FormGroup>
            </FormControl>
          </AppPaper>
        </>
      )}
    </AppPage>
  );
}

export default IntersectionDetails;
