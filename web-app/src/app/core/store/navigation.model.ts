import { Observable } from 'rxjs';

export default interface NavigationInfo {
  name: string;
  available: Observable<boolean>;
  values: {
    available: Observable<boolean>;
    icon: string;
    image: string;
    title: string;
    link: string;
    subtitle: string;
    description: string;
    linkDescription: string;
    requiredModuleId: string;
  }[];
}
