import type { Meta, StoryObj } from '@storybook/react';
import { fn } from '@storybook/test';
import { AppCardBg } from './AppCardBg.component';

// More on how to set up stories at: https://storybook.js.org/docs/writing-stories#default-export
const meta = {
  title: 'Cards/AppCardBg',
  component: AppCardBg,
} satisfies Meta<typeof AppCardBg>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {
  args: {
    label: 'Button',
    image: '/assets/card-img-traffic.jpg',
    title: 'Title',
    small: false,
    expanded: false,
  },
};
