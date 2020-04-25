package ak.eep.web.server.server;

public class Room {
    public static final String EEP_COMMAND = "[EEPCommand]";
    public static final String LOG = "[Log]";
    public static final String PING = "[Ping]";
    public static final String ROOM = "[Room]";
    public static final String AVAILABLE_DATA_TYPES = "[AvailableDataTypes]";

    public static String ofDataType(String dataType) {
        return "[Data-" + dataType + "]";
    }

    public static String dataTypeOf(String room) {
        if (room.startsWith("[Data-") && room.endsWith("]")) {
            return room.substring(6, room.length() - 1);
        }
        throw new IllegalStateException("No data room: " + room);
    }
}
