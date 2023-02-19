import BackIcon from '@mui/icons-material/ArrowBack';
import IconButton from '@mui/material/IconButton';
import { SxProps } from '@mui/material/styles';
import { useEffect } from 'react';
import { Link as RouterLink, useLocation, useNavigate } from 'react-router-dom';

function AppBackButton(props: { to?: string; sx?: SxProps }) {
  const navigate = useNavigate();
  const location = useLocation();

  if (location.pathname === '/') {
    return <></>;
  }

  return (
    <IconButton onClick={() => navigate(-1)} sx={props.sx}>
      <BackIcon />
    </IconButton>
  );
}

export default AppBackButton;
