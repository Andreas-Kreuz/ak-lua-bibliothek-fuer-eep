import { Status } from './status.enum';


export class StatusUtil {
  public static valueOf(s1: Status) {
    switch (s1) {
      case Status.SUCCESS:
        return 0;
      case Status.INFO:
        return 1;
      case Status.WARNING:
        return 2;
      case Status.ERROR:
        return 3;
    }
  }

  public static worstOf(s1: Status, s2: Status) {
    if (this.valueOf(s1) > this.valueOf(s2)) {
      return s1;
    } else {
      return s2;
    }
  }
}
