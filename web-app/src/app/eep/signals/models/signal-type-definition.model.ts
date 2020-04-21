export class SignalTypeDefinition {
  id: string;
  name: string;
  type: string;
  positions: {
    positionRed?: number,
    positionGreen?: number,
    positionYellow?: number,
    positionRedYellow?: number,
    positionPedestrians?: number,
    positionOff?: number,
    positionOffBlinking?: number,
  };


  static signalPositionName(signalModel: SignalTypeDefinition, signalPosition: number) {
    if (signalModel.positions.positionRed === signalPosition) {
      return 'Rot';
    } else if (signalModel.positions.positionGreen === signalPosition) {
      return 'Grün';
    } else if (signalModel.positions.positionYellow === signalPosition) {
      return 'Gelb';
    } else if (signalModel.positions.positionRedYellow === signalPosition) {
      return 'Rot-Gelb';
    } else if (signalModel.positions.positionPedestrians === signalPosition) {
      return 'Fussgänger';
    } else if (signalModel.positions.positionOff === signalPosition) {
      return 'Aus';
    } else if (signalModel.positions.positionOffBlinking === signalPosition) {
      return 'Aus-Blinkend';
    }
    return '?';
  }
}
