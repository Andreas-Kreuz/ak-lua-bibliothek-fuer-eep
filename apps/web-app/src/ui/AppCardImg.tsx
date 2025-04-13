import MuiBox from '@mui/material/Box';
import MuiCard from '@mui/material/Card';
import MuiCardActionArea from '@mui/material/CardActionArea';
import MuiCardMedia from '@mui/material/CardMedia';
import MuiChip from '@mui/material/Chip';
import MuiStack from '@mui/material/Stack';
import MuiTypography from '@mui/material/Typography';
import { Link as RouterLink } from 'react-router-dom';

export interface AppCardImgProps {
  title: string;
  subtitle?: string;
  id?: string;
  image?: string;
  to?: string;
  small?: boolean;
}

function AppCardImg(props: AppCardImgProps) {
  const contents = (
    <>
      <MuiTypography variant="h5">{props.title}</MuiTypography>
      {props.subtitle && (
        <MuiTypography variant="body1" sx={{ color: 'text.secondary' }}>
          {props.subtitle}
        </MuiTypography>
      )}
      {props.id && <MuiChip label={props.id} />}
    </>
  );

  const stack = (
    <MuiStack sx={{ flexDirection: { xs: 'row', sm: 'column' } }}>
      {props.image && (
        <MuiCardMedia
          component="img"
          image={props.image}
          title={props.title}
          sx={{
            width: { xs: '25%', sm: 1 },
          }}
        />
      )}
      <MuiBox sx={{ p: 2 }}>{contents}</MuiBox>
    </MuiStack>
  );

  return (
    <MuiCard sx={{ flexGrow: 1, display: 'flex', alignItems: 'stretch', alignContent: 'stretch' }}>
      {(props.to && (
        <MuiCardActionArea
          sx={{ display: 'flex', alignItems: 'stretch', alignContent: 'stretch' }}
          component={RouterLink}
          to={props.to}
        >
          {stack}
        </MuiCardActionArea>
      )) || <MuiBox sx={{ display: 'flex', alignItems: 'stretch', alignContent: 'stretch' }}>{stack}</MuiBox>}
    </MuiCard>
  );
}

export default AppCardImg;
