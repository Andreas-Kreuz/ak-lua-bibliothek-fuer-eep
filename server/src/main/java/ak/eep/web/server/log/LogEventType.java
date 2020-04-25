package ak.eep.web.server.log;

public enum LogEventType {
    LOG_ADD_MESSAGES("Lines Added"), LOG_CLEAR_MESSAGES("Lines Cleared");

    private final String stringValue;

    LogEventType(String stringValue) {
        this.stringValue = stringValue;
    }

    public String getStringValue() {
        return stringValue;
    }
}
