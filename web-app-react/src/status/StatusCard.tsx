import { Card, CardContent, Stack, Typography } from '@mui/material';

function StatusCard(props: {
  icon: any;
  name: string;
  statusColor: string;
  statusText: string;
  statusDescription: string;
}) {
  return (
    <Card
      className="card"
      sx={{
        borderLeft: 12,
        borderColor: props.statusColor + '.light',
      }}
    >
      <CardContent>
        <Stack direction="row" alignItems="center" justifyContent="space-between">
          <Typography className="cardTitleWithIcon" variant="h5" color={props.statusColor + '.main'} component="div">
            {props.name}
          </Typography>
          {props.icon}
        </Stack>
        <Typography gutterBottom variant="body2" color={props.statusColor + '.main'} sx={{ fontWeight: 'bold' }}>
          {props.statusText}
        </Typography>
        <Typography variant="body2">{props.statusDescription}</Typography>
      </CardContent>
    </Card>
  );
}

export default StatusCard;
