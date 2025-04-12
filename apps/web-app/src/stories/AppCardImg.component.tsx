import MyAppCardImg, { AppCardImgProps as MyAppCardProps } from '../ui/AppCardImg';

export interface AppCardImgProps extends MyAppCardProps {
  label: string;
}

export const AppCardImg = ({ label, ...rest }: AppCardImgProps) => <MyAppCardImg {...rest}>{label}</MyAppCardImg>;
