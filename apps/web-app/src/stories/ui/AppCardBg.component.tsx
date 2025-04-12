import MyAppCardBg, { AppCardBgProps as MyAppCardProps } from '../../ui/AppCardBg';
import { BrowserRouter } from 'react-router-dom';

export interface AppCardBgProps extends MyAppCardProps {
  label: string;
}

const Template = (args) => (
  <BrowserRouter>
    <MyAppCardBg {...args}></MyAppCardBg>
  </BrowserRouter>
);

export const AppCardBg = Template.bind({});
