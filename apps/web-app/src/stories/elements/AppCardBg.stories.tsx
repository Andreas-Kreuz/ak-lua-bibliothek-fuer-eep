import type { Meta, StoryObj } from '@storybook/react';
import { fn } from 'storybook/test';
import { AppCardBg } from './AppCardBg.component';

// More on how to set up stories at: https://storybook.js.org/docs/writing-stories#default-export
const meta = {
  title: 'Elements/Cards/CardBg',
  component: AppCardBg,
} satisfies Meta<typeof AppCardBg>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Title: Story = {
  args: {
    image: '/assets/card-img-traffic.jpg',
    title: 'Title',
    small: false,
    expanded: false,
  },
};

export const TitleOnMobile: Story = {
  args: {
    image: '/assets/card-img-traffic.jpg',
    title: 'Title',
    small: false,
    expanded: false,
  },
  globals: {
    viewport: { value: 'mobile1', isRotated: false },
  },
  tags: ['mobile'],
};

export const TitleOnMobileLong: Story = {
  args: {
    image: '/assets/card-img-traffic.jpg',
    title: 'Langer Titel',
    small: false,
    expanded: false,
  },
  globals: {
    viewport: { value: 'mobile1', isRotated: false },
  },
  tags: ['mobile'],
};
