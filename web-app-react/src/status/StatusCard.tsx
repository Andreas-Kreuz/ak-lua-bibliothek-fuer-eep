import { Box, Card, CardContent, Stack, Typography } from '@mui/material';
import CheckCircleOutlineRoundedIcon from '@mui/icons-material/CheckCircleOutlineRounded';
import RunningWithErrorsRoundedIcon from '@mui/icons-material/RunningWithErrorsRounded';
import WarningRoundedIcon from '@mui/icons-material/WarningRounded';

function StatusCard(props: {
  name: string;
  icon: 'ok' | 'error' | 'time';
  statusColor: 'success' | 'error' | 'warning';
  statusText: string;
  statusDescription: string;
}) {
  return (
    <Card className="card" sx={{ borderRadius: 0, boxShadow: 0, border: 1, borderColor: '#dddddd' }}>
      <Stack direction="row" alignItems="start" justifyContent="start" padding="0" margin="0">
        <Box
          sx={{
            p: 2,
            pt: 2.5,
            backgroundColor: props.statusColor + '.main',
            height: '100%',
            color: '#ffffff',
          }}
        >
          {props.icon === 'ok' ? (
            <CheckCircleOutlineRoundedIcon sx={{ fontSize: 24 }} />
          ) : props.icon === 'error' ? (
            <WarningRoundedIcon sx={{ fontSize: 24 }} />
          ) : (
            <RunningWithErrorsRoundedIcon sx={{ fontSize: 24 }} />
          )}
        </Box>
        <CardContent sx={{ p: 2 }}>
          <Typography className="cardTitleWithIcon" variant="h5" component="div">
            {props.name}
          </Typography>
          <Typography gutterBottom variant="body2" color={props.statusColor + '.main'} sx={{ fontWeight: 'bold' }}>
            {props.statusText}
          </Typography>
          <Typography variant="body2">{props.statusDescription}</Typography>
        </CardContent>
      </Stack>
    </Card>
  );
}

export default StatusCard;
