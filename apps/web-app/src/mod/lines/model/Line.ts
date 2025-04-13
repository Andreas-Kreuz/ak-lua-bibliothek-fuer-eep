import LineSegment from './LineSegment';

export default interface Line {
  id: number;
  nr: string;
  trafficType: 'BUS' | 'SUBWAY' | 'TRAM' | 'TRAIN';
  lineSegments: LineSegment[];
}
