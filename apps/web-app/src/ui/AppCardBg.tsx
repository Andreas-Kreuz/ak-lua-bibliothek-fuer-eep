import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import CardActionArea from '@mui/material/CardActionArea';
import Chip from '@mui/material/Chip';
import Divider from '@mui/material/Divider';
import Stack from '@mui/material/Stack';
import Typography from '@mui/material/Typography';
import { ReactNode } from 'react';
import { Link as RouterLink } from 'react-router-dom';

function AppCardBg(props: {
  children?: ReactNode;
  title: string;
  subtitle?: string;
  id?: string;
  additionalChips?: ReactNode[];
  to?: string;
  icon?: string;
  image: string;
  small?: boolean;
  expanded?: boolean;
  setExpanded?: (expanded: boolean) => void;
}) {
  const handleExpand = () => {
    if (props.setExpanded) {
      props.setExpanded(!props.expanded);
    }
  };
  const contents = (
    <Stack sx={{ flexDirection: 'column', alignItems: 'center' }}>
      <CardActionArea
        component={RouterLink}
        to={props.to || ''}
        onClick={handleExpand}
        disableRipple={((props.setExpanded || !props.to) && true) || false}
        sx={{
          p: 2,
          background:
            'radial-gradient(circle at right, ' +
            'rgba(255,255,255,0) 0px, rgba(255,255,255,0) 100px, rgba(255,255,255,1) 200px), ' +
            'url(' +
            props.image +
            ')',
          backgroundSize: 'auto 150%',
          backgroundPositionX: '100%',
          backgroundPositionY: '60%',
          backgroundRepeat: 'no-repeat',
        }}
      >
        <Typography variant="h5" gutterBottom>
          {props.title}
        </Typography>
        {props.subtitle && (
          <Typography variant="h5" gutterBottom>
            {props.subtitle}
          </Typography>
        )}
        <Stack direction="row" spacing={1} sx={{ '& .MuiChip-outlined': { backgroundColor: 'rgba(255,255,255,0.8)' } }}>
          {props.icon && <img src={props.icon} height="32" />}
          {props.id && <Chip label={props.id} />}
          {props.additionalChips && props.additionalChips.map((e) => e)}
        </Stack>
      </CardActionArea>
      {props.children}
    </Stack>
  );

  return <Card>{contents}</Card>;
}

export default AppCardBg;
