package ak.eep.web.server.jsondata;

import ak.eep.web.server.server.Room;
import ak.eep.web.server.server.WebsocketEvent;

public class AvailableDataTypesChangedEvent extends WebsocketEvent {

    public AvailableDataTypesChangedEvent(final String jsonEncoded) {
        super(Room.AVAILABLE_DATA_TYPES, "Set", jsonEncoded);
    }
}
