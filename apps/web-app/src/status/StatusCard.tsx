import CheckCircleOutlineRoundedIcon from '@mui/icons-material/CheckCircleOutlineRounded';
import RunningWithErrorsRoundedIcon from '@mui/icons-material/RunningWithErrorsRounded';
import WarningRoundedIcon from '@mui/icons-material/WarningRounded';
import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import Stack from '@mui/material/Stack';
import Typography from '@mui/material/Typography';

function StatusCard(props: {
  name: string;
  icon: 'ok' | 'error' | 'time';
  statusColor: 'success' | 'error' | 'warning';
  statusText: string;
  statusDescription: string;
}) {
  return (
    <Card
      sx={{ borderRadius: 0, boxShadow: 0, border: 1, borderColor: '#dddddd', display: 'flex', height: 1, width: 1 }}
    >
      <Stack sx={{ m: 0, p: 0, width: 1, flexDirection: 'row', alignItems: 'start', justifyContent: 'start' }}>
        <Box sx={{ backgroundColor: props.statusColor + '.main', color: '#ffffff', height: '100%', p: 2, pt: 2.5 }}>
          {props.icon === 'ok' ? (
            <CheckCircleOutlineRoundedIcon sx={{ fontSize: 24 }} />
          ) : props.icon === 'error' ? (
            <WarningRoundedIcon sx={{ fontSize: 24 }} />
          ) : (
            <RunningWithErrorsRoundedIcon sx={{ fontSize: 24 }} />
          )}
        </Box>
        <CardContent sx={{ p: 2, width: '100%' }}>
          <Typography variant="h5">{props.name}</Typography>
          <Typography gutterBottom variant="body1" sx={{ color: props.statusColor + '.main', fontWeight: 'bold' }}>
            {props.statusText}
          </Typography>
          <Typography variant="body2">{props.statusDescription}</Typography>
        </CardContent>
      </Stack>
    </Card>
  );
}

export default StatusCard;
