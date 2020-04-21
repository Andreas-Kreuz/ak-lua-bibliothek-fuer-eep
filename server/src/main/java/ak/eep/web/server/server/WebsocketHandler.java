package ak.eep.web.server.server;

import io.javalin.websocket.WsSession;
import org.jetbrains.annotations.NotNull;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.*;
import java.util.function.Consumer;
import java.util.function.Supplier;

public class WebsocketHandler {
    private static final Logger log = LoggerFactory.getLogger(WebsocketHandler.class);

    private final Map<String, List<Supplier<WebsocketEvent>>> onJoinRoomSuppliers = new TreeMap<>();
    private final Map<String, List<Consumer<WebsocketEvent>>> onRoomMsgConsumers = new TreeMap<>();
    private final Map<String, Set<WsSession>> roomSessions = new TreeMap<>();
    private final List<WsSession> sessions = new ArrayList<>();
    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
    private Timer timer = null;

    public WebsocketHandler() {
    }

    public void addOnMessageConsumer(String room, Consumer<WebsocketEvent> onMessageConsumer) {
        List<Consumer<WebsocketEvent>> list = this.onRoomMsgConsumers.computeIfAbsent(room, (r) -> new ArrayList<>());
        list.add(onMessageConsumer);
    }

    public void addOnJoinRoomSupplier(String room, Supplier<WebsocketEvent> initialSupplier) {
        List<Supplier<WebsocketEvent>> list = this.onJoinRoomSuppliers.computeIfAbsent(room, (r) -> new ArrayList<>());
        list.add(initialSupplier);
        log.info("Added Initial Supplier for: " + room + "");
    }

    public void removeRoom(String room) {
        this.onJoinRoomSuppliers.remove(room);
        this.onRoomMsgConsumers.remove(room);
    }

    void onConnect(WsSession session) {
        sessions.add(session);
        log.info("Session connected: " + session.getId());
    }

    void onMessage(WsSession session, String message) {
        WebsocketEvent event = decodeJson(message);
        log.info("INCOMING SOCKET: " + event.getRoom() + " " + event.getAction() + " from " + session.getId());
        computeRoomMessage(session, event);
        List<Consumer<WebsocketEvent>> consumers = onRoomMsgConsumers.getOrDefault(event.getRoom(),
                Collections.emptyList());
        consumers.forEach(c -> c.accept(event));
    }

    private void computeRoomMessage(WsSession session, WebsocketEvent websocketEvent) {
        if (Room.ROOM.equals(websocketEvent.getRoom())) {
            String changedRoom = websocketEvent.getPayload();
            if (RoomSubscriptionAction.SUBSCRIBE.action().equals(websocketEvent.getAction())) {
                joinRoom(session, changedRoom);
            } else if (RoomSubscriptionAction.UNSUBSCRIBE.action().equals(websocketEvent.getAction())) {
                leaveRoom(session, changedRoom);
            }
        }
    }

    void onClose(WsSession session, int statusCode, String reason) {
        log.info("Websocket Closed: " + statusCode + " " + reason + " " + session.getId());
        removeSession(session);
    }

    void onError(WsSession session, Throwable throwable) {
        log.info("Websocket Errored" + session.getId(), throwable);
        removeSession(session);
    }

    private void removeSession(WsSession session) {
        roomSessions.forEach((room, wsSessions) -> leaveRoom(session, room));
        sessions.remove(session);
    }

    private WebsocketEvent decodeJson(@NotNull String jsonMessage) {
        JSONObject o = new JSONObject(jsonMessage);
        if (null == o.get("room")) {
            log.info("NO type IN MESSAGE: " + o.toString());
        }
        if (null == o.get("action")) {
            log.info("NO action IN MESSAGE: " + o.toString());
        }
        String room = o.get("room").toString();
        String action = o.get("action").toString();
        String payload = o.get("payload") == null ? null : o.get("payload").toString();
        return new WebsocketEvent(room, action, payload);
    }

    private String jsonEncode(@NotNull WebsocketEvent action) {
        JSONObject jsonObject = new JSONObject(action);
        jsonObject.put("room", action.getRoom());
        jsonObject.put("action", action.getAction());
        jsonObject.put("payload", action.getPayload());
        return jsonObject.toString();
    }

    private void send(WsSession session, @NotNull WebsocketEvent event) {
        log.info("OUTBOUND SOCKET: " + event.getRoom() + " " + event.getAction() + " to " + session.getId());
        String jsonEncoded = jsonEncode(event);
        send(session, jsonEncoded);
    }

    public void broadcast(@NotNull WebsocketEvent event) {
        log.info("OUTBOUND BROADCAST: " + event.getRoom() + " " + event.getAction() + " to all");
        String jsonEncoded = jsonEncode(event);
        broadcast(event.getRoom(), jsonEncoded);
    }

    private void broadcast(String room, String jsonEventAndPayload) {
        roomSessions.getOrDefault(room, Collections.emptySet()).forEach(s -> send(s, jsonEventAndPayload));
    }

    private void send(WsSession session, String jsonEventAndPayload) {
        try {
            session.send(jsonEventAndPayload);
        } catch (Exception e) {
            log.info("Cannot send", e);
        }
    }

    private void joinRoom(WsSession session, String room) {
        synchronized (roomSessions) {
            Set<WsSession> set = this.roomSessions.computeIfAbsent(room, (r) -> new HashSet<>());
            if (set.add(session)) {
                log.info(room + " joined by " + session.getId());

                List<Supplier<WebsocketEvent>> initialSuppliers = this.onJoinRoomSuppliers.computeIfAbsent(room,
                        (r) -> new ArrayList<>());
                initialSuppliers.forEach(s -> send(session, s.get()));

                if (Room.PING.equals(room)) {
                    startPingTimerIfRequired();
                }
            }
        }
    }

    private void leaveRoom(WsSession session, String room) {
        synchronized (roomSessions) {
            Set<WsSession> set = this.roomSessions.get(room);
            if (set != null) {
                if (set.remove(session)) {
                    log.info(room + " left by " + session.getId());
                }
            }
        }

        if (Room.PING.equals(room)) {
            stopTimerIfRequired();
        }
    }

    private void startPingTimerIfRequired() {
        synchronized (roomSessions) {
            if (roomSessions.get(Room.PING) != null && !roomSessions.get(Room.PING).isEmpty() && timer == null) {
                timer = new Timer(true);
                timer.scheduleAtFixedRate(new TimerTask() {
                    @Override
                    public void run() {
                        broadcast(new WebsocketEvent(Room.PING, "Ping", sdf.format(new Date())));
                    }
                }, 1000, 5000);
                log.info("Ping service started");
            }
        }
    }

    private void stopTimerIfRequired() {
        synchronized (roomSessions) {
            if (roomSessions.get(Room.PING) != null && roomSessions.get(Room.PING).size() == 0 && timer != null) {
                timer.cancel();
                timer = null;
                log.info("Ping service stopped");
            }
        }
    }

    public void disconnect() {
        for (WsSession session : sessions) {
            session.close(0, "Server shutdown");
        }
    }
}
