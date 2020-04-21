package ak.eep.web.server.server;

public enum RoomSubscriptionAction {
    SUBSCRIBE("Subscribe"), UNSUBSCRIBE("Unsubscribe");

    private final String stringValue;

    RoomSubscriptionAction(String stringValue) {
        this.stringValue = stringValue;
    }

    public String action() {
        return stringValue;
    }
}
