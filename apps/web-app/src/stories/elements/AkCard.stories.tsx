import type { Meta, StoryObj } from '@storybook/react';
import { fn } from 'storybook/test';
import { AkCard } from './AkCard.component';

// More on how to set up stories at: https://storybook.js.org/docs/writing-stories#default-export
const meta = {
  title: 'Elements/Cards/Card',
  tags: ['autodocs'],
  component: AkCard,
} satisfies Meta<typeof AkCard>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {},
};

export const CardOnMobile: Story = {
  args: {},
  globals: {
    viewport: { value: 'mobile1', isRotated: false },
  },
  tags: ['mobile'],
};
