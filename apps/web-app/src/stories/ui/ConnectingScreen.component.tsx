import MyConnectingScreen, { ConnectingScreenProps as MyConnectingScreenProps } from '../../ui/ConnectingScreen';

export type ConnectingScreenProps = Omit<MyConnectingScreenProps, 'children'>;

export const ConnectingScreen = ({ ...args }: ConnectingScreenProps) => (
  <div style={{ minHeight: '20rem' }}>
    <MyConnectingScreen {...args} />
  </div>
);

export default ConnectingScreen;
