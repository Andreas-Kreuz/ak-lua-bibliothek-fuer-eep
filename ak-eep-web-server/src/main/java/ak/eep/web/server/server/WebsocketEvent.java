package ak.eep.web.server.server;

public class WebsocketEvent {
    private String room;
    private String action;
    private String payload;

    public WebsocketEvent(String room, String action, String payload) {
        this.room = room;
        this.action = action;
        this.payload = payload;
    }

    public String getRoom() {
        return this.room;
    }

    public String getAction() {
        return this.action;
    }

    public String getPayload() {
        return payload;
    }

    @Override
    public String toString() {
        return "WebsocketEvent{" + "room='" + room + '\'' + "action='" + action + '\'' + ", payload='" + payload + '\''
                + '}';
    }
}
