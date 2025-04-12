import MyAppCardBg, { AppCardBgProps as MyAppCardProps } from '../ui/AppCardBg';

export interface AppCardBgProps extends MyAppCardProps {
  label: string;
}

export const AppCardBg = ({ label, ...rest }: AppCardBgProps) => <MyAppCardBg {...rest}>{label}</MyAppCardBg>;
