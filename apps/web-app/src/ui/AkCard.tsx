import Card from '@mui/material/Card';
import CardActionArea from '@mui/material/CardActionArea';
import { ReactNode } from 'react';

export interface AkCardProps {
  children?: ReactNode;
}

const AkCard = (props: AkCardProps) => {
  return <Card>{props.children}</Card>;
};

export default AkCard;
