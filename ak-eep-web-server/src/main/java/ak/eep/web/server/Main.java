package ak.eep.web.server;

import ak.eep.web.server.io.CommandWriter;
import ak.eep.web.server.io.DirectoryWatcher;
import ak.eep.web.server.io.FileContentReader;
import ak.eep.web.server.io.LogFileWatcher;
import ak.eep.web.server.jsondata.AvailableDataTypesChangedEvent;
import ak.eep.web.server.jsondata.JsonContentProvider;
import ak.eep.web.server.log.LogClearedEvent;
import ak.eep.web.server.log.LogLinesAddedEvent;
import ak.eep.web.server.server.Room;
import ak.eep.web.server.server.Server;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;

public class Main {
    private static Logger log = LoggerFactory.getLogger(Main.class);
    private static boolean testMode;
    private final Path jsonDataFilePath;
    private final Path logInFilePath;
    private final Path commandOutFilePath;
    private final Path serverSyncFilePath;
    private final Path luaReadyFilePath;
    private DirectoryWatcher directoryWatcher;

    private Main(Path dir) throws IOException {
        this.directoryWatcher = new DirectoryWatcher(dir).watchFilesInBg();

        this.commandOutFilePath = Paths.get(dir + "/ak-eep-in.commands").toAbsolutePath();
        this.logInFilePath = Paths.get(dir + "/ak-eep-out.socket").toAbsolutePath();
        this.jsonDataFilePath = Paths.get(dir + "/ak-eep-out.json").toAbsolutePath();
        this.serverSyncFilePath = Paths.get(dir + "/ak-server.iswatching").toAbsolutePath();
        // this.serverReadyFileName =
        // Paths.get(dir +
        // "/ak_out_eep-web-server.server-is-ready-for-data").toAbsolutePath();
        this.luaReadyFilePath = Paths.get(dir + "/ak-eep-out-json.isfinished").toAbsolutePath();

        File serverSyncFile = this.serverSyncFilePath.toFile();
        // noinspection ResultOfMethodCallIgnored
        serverSyncFile.createNewFile();
        serverSyncFile.deleteOnExit();

        File luaReadyFile = luaReadyFilePath.toFile();
        // noinspection ResultOfMethodCallIgnored
        luaReadyFile.delete();
        luaReadyFile.deleteOnExit();
    }

    public static void main(String[] args) throws IOException {
        Path dir = parseArguments(args);

        Main main = new Main(dir);
        main.startServer();
    }

    private static Path parseArguments(String[] args) throws IOException {
        if (args.length > 0 && "--test".equals(args[0])) {
            testMode = true;
            args = Arrays.copyOfRange(args, 1, args.length);
        }

        Path configFilePath = Paths.get("eep-lua-out-dir.txt").toAbsolutePath();
        String directoryName;
        if (args.length > 0) {
            directoryName = args[0];
        } else {
            File dirFile = configFilePath.toFile();
            directoryName = dirFile.exists() ? new FileContentReader().readFileContentDefault(configFilePath) : "out";
        }
        return checkPathsOrExit(directoryName, configFilePath);
    }

    private static Path checkPathsOrExit(String directoryName, Path configFilePath) {
        Path dir = Paths.get(directoryName);
        if (!dir.toFile().isDirectory()) {
            System.out.println("---------------------------------" + "\nPfad nicht gefunden."
                    + "\n---------------------------------" + "\n" + "\nDer Pfad \"" + dir.toFile().getAbsoluteFile()
                    + "\" ist kein Verzeichnis."
                    + "\nBitte gib das Verzeichnis \"\\LUA\\ak\\io\\exchange\" in der EEP-Installation an." + "\n"
                    + "\n   z.B.: * \"C:\\Trend\\EEP14\\LUA\\ak\\io\\exchange\""
                    + "\n         * \"C:\\Trend\\EEP15\\LUA\\ak\\io\\exchange\"" + "\n"
                    + "\nHinweis: Du kannst dieses Verzeichnis ohne abschließenden Zeilenumbruch in die "
                    + "\n         Datei \"" + configFilePath + "\" schreiben.");
            System.exit(1);
        }
        return dir;
    }

    private void startServer() {
        log.info("" + "\nCommands will be written to: " + commandOutFilePath + "\nLogs will be read from     : "
                + logInFilePath + "\nJSON data will be read from: " + jsonDataFilePath);

        final Server server = new Server(testMode);
        connectJsonContentProvider(server);
        connectCommandWriter(server);
        connectLogFileWatcher(server);
        server.startServer();

        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            server.getWebsocketHandler().disconnect();
            log.info("Exited correctly ...");
        }));
    }

    private void connectLogFileWatcher(Server server) {
        LogFileWatcher logFileWatcher = new LogFileWatcher(logInFilePath);
        directoryWatcher.addFileConsumer(logInFilePath, logFileWatcher);
        logFileWatcher.addLogLineConsumer((logLines, reset) -> {
            if (reset) {
                server.getWebsocketHandler().broadcast(new LogClearedEvent());
            }
            server.getWebsocketHandler().broadcast(new LogLinesAddedEvent(logLines));
        });
        server.getWebsocketHandler().addOnJoinRoomSupplier(Room.LOG,
                () -> new LogLinesAddedEvent(logFileWatcher.getAllCurrentLogLines()));
    }

    private void connectCommandWriter(Server server) {
        final CommandWriter commandWriter = new CommandWriter(commandOutFilePath);
        server.getWebsocketHandler().addOnMessageConsumer(Room.EEP_COMMAND, (websocketEvent) -> {
            log.info("Executing: " + websocketEvent);
            commandWriter.writeCommand(websocketEvent.getPayload());
        });
    }

    private void connectJsonContentProvider(Server server) {
        final JsonContentProvider jsonContentProvider = new JsonContentProvider(server);
        jsonContentProvider.roomAdded(
                (room, initialProvider) -> server.getWebsocketHandler().addOnJoinRoomSupplier(room, initialProvider));
        jsonContentProvider.roomRemoved((room) -> server.getWebsocketHandler().removeRoom(room));
        updateJsonData(jsonContentProvider);

        directoryWatcher.addFileConsumer(luaReadyFilePath, (path, change) -> {
            if (change == DirectoryWatcher.Change.CREATED || change == DirectoryWatcher.Change.MODIFIED) {
                if (!luaReadyFilePath.getFileName().equals(path.getFileName())) {
                    log.error("NOT MATCHING: \n" + luaReadyFilePath.toFile().getAbsolutePath() + "\n"
                            + path.toFile().getAbsolutePath());
                }

                updateJsonData(jsonContentProvider);
                // noinspection ResultOfMethodCallIgnored
                luaReadyFilePath.toFile().delete();
            }
        });
        server.getWebsocketHandler().addOnJoinRoomSupplier(Room.AVAILABLE_DATA_TYPES,
                () -> new AvailableDataTypesChangedEvent(jsonContentProvider.getAllCurrentDataTypes()));

    }

    private void updateJsonData(JsonContentProvider jsonContentProvider) {
        try {
            log.info("Read file: " + jsonDataFilePath);
            String json = new FileContentReader().readFileContentWin1252(jsonDataFilePath);
            jsonContentProvider.updateInput(json);
        } catch (IOException e) {
            log.error("Cannot read file: " + jsonDataFilePath, e);
        }
    }
}
