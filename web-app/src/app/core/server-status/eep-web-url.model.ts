import { Status } from './status.enum';

export class EepWebUrl {
  constructor(
    public path: string,
    public status: Status,
    public message: string,
    public updated?: string) {

  }
}
