# Map Data

These files are input for the EEP-Webserver.

- The initial run is written to 1 - 30
- The second run (update) is written to the events from 30 to 81

Created with:

1. **Close EEP-Web-Server** if running

2. **Create watching file** in the game folder of EEP to simulate the server  
   `lua\ak\io\exchange\ak-server.iswatching`

3. **Start EEP or reload the Lua Script**
   so EEP can write the event file

4. **Run Parser from the server directory**
   `cd web-server`  
   `npm run persist-eep-state`

   This will read the file `ak-eep-out.json` and write the output to the folder
   `../web-app/cypress/fixtures/from-eep`

5. **Follow-up events can be parsed** with the following chain:

   1. Let EEP run until the desired state is reached
   2. Remove the file `ak-eep-out-json.ready` in `lua\ak\io\exchange\`  
      (This will tell EEP to write events in the next cycle.)
   3. Let EEP run - so it can write the eventlog.
   4. Run `npm run persist-eep-state` in the `web-server` directory.

Finally all event files can be moved to a new map directory.
