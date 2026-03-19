import type { Meta, StoryObj } from '@storybook/react';
import { fn } from 'storybook/test';
import ConnectingScreen from './ConnectingScreen.component';

// More on how to set up stories at: https://storybook.js.org/docs/writing-stories#default-export
const meta = {
  title: 'Screens/ConnectingScreen',
  // tags: ['autodocs'],
  component: ConnectingScreen,
} satisfies Meta<typeof ConnectingScreen>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: { url: 'mein-langer-servername.zuhause:3000' },
};

export const OnMobileScreen: Story = {
  args: Default.args,
  parameters: {},
  globals: {
    viewport: { value: 'mobile1', isRotated: false },
  },
  tags: ['mobile'],
};
