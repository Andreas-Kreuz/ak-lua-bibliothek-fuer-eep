import { useState } from 'react';

const dataLuaModuleId = 'e538a124-3f0a-4848-98cf-02b08563bf32'; // "ak.data.DataLuaModule"
const kreuzungLuaModuleId = 'c5a3e6d3-0f9b-4c89-a908-ed8cf8809362'; // "ak.data.KreuzungLuaModul"
const publicTransportLuaModuleId = '83ce6b42-1bda-45e0-8b4a-e8daeed047ab'; // "ak.public-transport.PublicTransportLuaModul"

function useNavState(): {
  name: string;
  available: boolean;
  values: {
    available: boolean;
    icon: string;
    image?: string;
    title: string;
    subtitle?: string;
    link: string;
    description?: string;
    linkDescription?: string;
    requiredModuleId?: string;
  }[];
}[] {
  const [availLuaData, setAvailLuaData] = useState(false);
  const [availIntersection, setAvailIntersection] = useState(false);
  const [availPublicTransport, setAvailPublicTransport] = useState(false);
  const [availModules, setAvailModules] = useState(false);

  const navigation = [
    {
      name: 'Home',
      available: true,
      values: [
        {
          available: true,
          icon: 'home',
          image: undefined,
          title: 'Home',
          link: '/',
          subtitle: undefined,
          description: undefined,
          linkDescription: undefined,
          requiredModuleId: undefined,
        },
      ],
    },
    {
      name: 'Verkehr',
      available: availLuaData && (availIntersection || availPublicTransport),
      values: [
        {
          available: availIntersection,
          icon: 'gamepad',
          title: 'Ampelkreuzungen',
          subtitle: 'Steuern mit der Lua-Bibliothek',
          link: '/intersections',
          image: 'card-img-intersection.jpg',
          description: 'Schalte Deine Kreuzungen oder setze die passende Kamera.',
          linkDescription: 'Kreuzungen zeigen',
          requiredModuleId: kreuzungLuaModuleId,
        },
        {
          available: availPublicTransport,
          icon: 'route',
          title: 'ÖPNV-Linien',
          subtitle: 'Nahverkehr mit der Lua-Bibliothek',
          link: '/public-transport',
          image: 'card-img-traffic.jpg',
          description: 'Schaue Deine Nahverkehrslinien und -Haltestellen an.',
          linkDescription: 'ÖNPV anzeigen',
          requiredModuleId: publicTransportLuaModuleId,
        },
        {
          available: availLuaData,
          icon: 'directions_car',
          title: 'Fahrzeuge',
          subtitle: 'Gekoppelte Fahrzeuge und Züge',
          link: '/trains',
          image: 'card-img-trains-all.jpg',
          description: 'Hier findest Du auch Trams, die auf der Straße fahren.',
          linkDescription: 'Fahrzeuge zeigen',
          requiredModuleId: dataLuaModuleId,
        },
        // {
        //   available: availLuaData,
        //   icon: 'directions_car',
        //   title: 'Autos',
        //   subtitle: 'Straßen',
        //   link: '/trains/road',
        //   image: 'card-img-trains-road.jpg',
        //   description: 'Hier findest Du auch Trams, die auf der Straße fahren.',
        //   linkDescription: 'Autos zeigen',
        //   requiredModuleId: dataLuaModuleId,
        // },
        // {
        //   available: availLuaData,
        //   icon: 'tram',
        //   title: 'Trams',
        //   subtitle: 'Straßenbahngleise',
        //   link: '/trains/tram',
        //   image: 'card-img-trains-tram.jpg',
        //   description: 'Trams, die auf der Straße fahren, findest Du unter Autos.',
        //   linkDescription: 'Trams zeigen',
        //   requiredModuleId: dataLuaModuleId,
        // },
        // {
        //   available: availLuaData,
        //   icon: 'train',
        //   title: 'Züge',
        //   subtitle: 'Bahngleise',
        //   link: '/trains/rail',
        //   image: 'card-img-trains-rail.jpg',
        //   description: 'Fahrzeuge, die auf Bahngleisen unterwegs sind.',
        //   linkDescription: 'Züge zeigen',
        //   requiredModuleId: dataLuaModuleId,
        // },
      ],
    },
    {
      name: 'Daten',
      available: true,
      values: [
        {
          available: true,
          icon: 'message',
          title: 'Log',
          subtitle: undefined, // 'EEP-Log-Datei',
          link: '/log',
          image: undefined,
          description: 'Zeige die Log-Datei von EEP an',
          linkDescription: 'Log-Datei ansehen',
          requiredModuleId: undefined,
        },
        {
          available: availLuaData,
          icon: 'memory',
          title: 'Speicher',
          subtitle: undefined, // 'EEPDataSlot',
          link: '/data',
          image: undefined,
          description: 'Mit EEPSaveData gespeicherte Felder',
          linkDescription: 'Zu den Daten',
          requiredModuleId: dataLuaModuleId,
        },
        {
          available: availLuaData,
          icon: 'traffic',
          title: 'Signale',
          subtitle: undefined, // 'Ampeln, Signale, Schranken',
          link: '/signals',
          image: undefined,
          description: 'Enthält Signale, Ampeln und Schranken',
          linkDescription: 'Zu den Signalen',
          requiredModuleId: dataLuaModuleId,
        },
        {
          available: availModules,
          icon: 'list_alt',
          title: 'Roh-Daten',
          subtitle: undefined, // 'JSON-Daten vom Server',
          link: '/generic-data',
          image: undefined,
          description: 'Übersicht der Rohdaten von EEP-Web',
          linkDescription: 'Zu den Daten',
          requiredModuleId: undefined,
        },
      ],
    },
  ];

  return navigation;
}

export default useNavState;
