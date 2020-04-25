package ak.eep.web.server.jsondata;

import ak.eep.web.server.server.WebsocketEvent;

public class DataChangedEvent extends WebsocketEvent {
    public DataChangedEvent(String room, String dataAsJson) {
        super(room, "Set", dataAsJson);
    }
}
