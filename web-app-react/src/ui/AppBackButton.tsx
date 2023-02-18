import BackIcon from '@mui/icons-material/ArrowBack';
import IconButton from '@mui/material/IconButton';
import { Link as RouterLink } from 'react-router-dom';

function AppBackButton(props: { to: string }) {
  return (
    <IconButton component={RouterLink} to={props.to}>
      <BackIcon />
    </IconButton>
  );
}

export default AppBackButton;
