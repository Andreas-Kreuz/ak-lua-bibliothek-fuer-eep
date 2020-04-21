package ak.eep.web.server.log;

import ak.eep.web.server.server.WebsocketEvent;

public class LogLinesAddedEvent extends WebsocketEvent {
    public LogLinesAddedEvent(String logLines) {
        super("[Log]", LogEventType.LOG_ADD_MESSAGES.getStringValue(), logLines);
    }
}
