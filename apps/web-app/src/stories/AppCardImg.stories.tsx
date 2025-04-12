import type { Meta, StoryObj } from '@storybook/react';
import { fn } from '@storybook/test';
import { AppCardImg } from './AppCardImg.component';

// More on how to set up stories at: https://storybook.js.org/docs/writing-stories#default-export
const meta = {
  title: 'Cards/AppCardImg',
  tags: ['autodocs'],
  component: AppCardImg,
} satisfies Meta<typeof AppCardImg>;

export default meta;
type Story = StoryObj<typeof meta>;

export const TitleOnly: Story = {
  args: {
    label: 'Button',
    image: '/assets/card-img-traffic.jpg',
    title: 'Title',
  },
};
export const TitleAndSubtitle: Story = {
  args: {
    label: 'Button',
    image: '/assets/card-img-traffic.jpg',
    title: 'Title',
    subtitle: 'Subtitle',
  },
};
export const TitleAndId: Story = {
  args: {
    label: 'Button',
    image: '/assets/card-img-traffic.jpg',
    title: 'Title',
    id: 'My very long ID',
  },
};
