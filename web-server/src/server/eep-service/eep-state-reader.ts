import fs from 'fs';
import path from 'path';

const persistState = () => {
  const jsonFile = path.resolve('../lua/LUA/ak/io/exchange/ak-eep-out.json');
  const data: string = fs.readFileSync(jsonFile, { encoding: 'latin1' });
  const eventLines: string[] = data.split('\n');
  for (const line of eventLines) {
    if (line.length > 0) {
      const event = JSON.parse(line);

      console.log(
        'Event ' + event.eventCounter + ' ' + event.payload.room + ' (' + line.length.toLocaleString('de-DE') + ')'
      );

      fs.writeFileSync(
        path.resolve('../web-app/cypress/fixtures/from-eep/eep-event' + event.eventCounter + '.json'),
        JSON.stringify(event),
        { encoding: 'latin1' }
      );
    }
  }
};

persistState();
