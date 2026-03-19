import type { Meta, StoryObj } from '@storybook/react';
import { fn } from 'storybook/test';
import VersionInfo from './VersionInfo.component';

const meta = {
  title: 'Module Elements/Statistics/VersionInfo',
  tags: ['element'],
  component: VersionInfo,
} satisfies Meta<typeof VersionInfo>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: { appVersion: '0.13.2', eepVersion: '18.0', luaVersion: '5.3' },
};

export const OnMobile: Story = {
  args: { appVersion: '0.13.2', eepVersion: '18.0', luaVersion: '5.3' },
  globals: { viewport: { value: 'mobile1', isRotated: false } },
  tags: ['mobile'],
};
