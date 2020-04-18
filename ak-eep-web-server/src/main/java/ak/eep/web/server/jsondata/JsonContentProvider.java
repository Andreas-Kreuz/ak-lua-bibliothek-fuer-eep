package ak.eep.web.server.jsondata;

import ak.eep.web.server.server.Room;
import ak.eep.web.server.server.Server;
import ak.eep.web.server.server.WebsocketEvent;
import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;
import java.util.function.BiConsumer;
import java.util.function.Consumer;
import java.util.function.Supplier;

/**
 * Provide contents for the webserver under a certain URL.
 */
public class JsonContentProvider {
    private static Logger log = LoggerFactory.getLogger(JsonContentProvider.class);

    private final Map<String, String> dataTypesToContent = new HashMap<>();
    private final SortedSet<String> currentDataTypes = new TreeSet<>();
    private final Server server;
    private BiConsumer<String, Supplier<WebsocketEvent>> roomAddedConsumer = null;
    private Consumer<String> roomRemovedConsumer = null;

    public JsonContentProvider(Server server) {
        this.server = server;
    }

    public void updateInput(String json) {
        final JSONObject object = new JSONObject(json);
        final SortedSet<String> dataTypes = new TreeSet<>(object.keySet());
        final boolean dataTypesChanged = updateDataTypes(dataTypes);
        log.debug("Found Datatypes: " + dataTypes);

        for (String dataType : dataTypes) {
            final String jsonForUrl = object.get(dataType).toString();
            final String lastJsonForUrl = dataTypesToContent.get(dataType);
            dataTypesToContent.put(dataType, jsonForUrl);
            registerServerUrl(dataType);
            sendEventOnChange(dataType, jsonForUrl, lastJsonForUrl);
        }

        if (dataTypesChanged) {
            sendDataTypeChangeEvent();
        }
    }

    private void sendEventOnChange(String dataType, final String jsonForUrl, final String lastJsonForUrl) {
        final String room = Room.ofDataType(dataType);
        if (!jsonForUrl.equals(lastJsonForUrl)) {
            server.getWebsocketHandler().broadcast(new DataChangedEvent(room, jsonForUrl));
        }
    }

    private String registerServerUrl(String dataType) {
        final String url = "/api/v1/" + dataType;
        if (!server.urlUsed(url)) {
            server.addServerUrl(url, () -> dataTypesToContent.get(dataType));
        }
        return url;
    }

    private void sendDataTypeChangeEvent() {
        JSONArray array = new JSONArray();
        currentDataTypes.forEach(s -> array.put(s));
        server.getWebsocketHandler().broadcast(new AvailableDataTypesChangedEvent(array.toString()));
    }

    private synchronized boolean updateDataTypes(Set<String> dataTypes) {
        for (String dataType : dataTypes) {
            if (roomAddedConsumer != null && !currentDataTypes.contains(dataType)) {
                final String room = Room.ofDataType(dataType);
                roomAddedConsumer.accept(room, () -> new DataChangedEvent(room, dataTypesToContent.get(dataType)));
            }
        }

        for (String dataType : currentDataTypes) {
            if (roomRemovedConsumer != null && !dataTypes.contains(dataType)) {
                final String room = Room.ofDataType(dataType);
                roomRemovedConsumer.accept(room);
                dataTypesToContent.put(dataType, "");
            }
        }

        boolean changed = false;
        changed |= currentDataTypes.retainAll(dataTypes);
        changed |= currentDataTypes.addAll(dataTypes);

        return changed;
    }

    public synchronized String getAllCurrentDataTypes() {
        JSONArray array = new JSONArray();
        currentDataTypes.forEach(s -> array.put(s));
        return array.toString();
    }

    public void roomAdded(BiConsumer<String, Supplier<WebsocketEvent>> roomAddedConsumer) {
        this.roomAddedConsumer = roomAddedConsumer;
    }

    public void roomRemoved(Consumer<String> roomRemovedConsumer) {
        this.roomRemovedConsumer = roomRemovedConsumer;
    }
}
