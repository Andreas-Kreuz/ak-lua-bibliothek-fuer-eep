package ak.eep.web.server.io;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.nio.file.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.BiConsumer;

/**
 * Watch directory for file changes.
 */
public class DirectoryWatcher {
    private static Logger log = LoggerFactory.getLogger(DirectoryWatcher.class);
    private final Map<String, BiConsumer<Path, Change>> fileConsumers;
    private final WatchService watchService;

    public DirectoryWatcher(Path directory) throws IOException {
        this.fileConsumers = new ConcurrentHashMap<>();
        log.info("Listening for changes in: " + directory);
        this.watchService = FileSystems.getDefault().newWatchService();
        directory.register(this.watchService, StandardWatchEventKinds.ENTRY_CREATE,
                StandardWatchEventKinds.ENTRY_MODIFY, StandardWatchEventKinds.ENTRY_DELETE,
                StandardWatchEventKinds.OVERFLOW);
    }

    public void addFileConsumer(Path path, BiConsumer<Path, Change> fileConsumer) {
        String fileName = path.getFileName().toString();
        this.fileConsumers.putIfAbsent(fileName, fileConsumer);
    }

    /**
     * All changes will be sent to their consumers.
     */
    private void watchFiles() {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
        try {
            WatchKey key;
            while ((key = watchService.take()) != null) {
                for (WatchEvent<?> event : key.pollEvents()) {
                    log.debug(simpleDateFormat.format(new Date()) + ": File: " + event.context() + " (" + event.kind()
                            + ").");
                    final Change change = getChange(event.kind());
                    if (event.context() instanceof Path) {
                        Path path = (Path) event.context();
                        String fileName = path.getFileName().toString();
                        BiConsumer<Path, Change> consumer = fileConsumers.getOrDefault(fileName, null);
                        if (consumer != null) {
                            consumer.accept(path, change);
                        }
                    }
                }
                key.reset();
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    private Change getChange(WatchEvent.Kind<?> kind) {
        if (kind == StandardWatchEventKinds.ENTRY_CREATE) {
            return Change.CREATED;
        } else if (kind == StandardWatchEventKinds.ENTRY_MODIFY) {
            return Change.MODIFIED;
        } else if (kind == StandardWatchEventKinds.OVERFLOW) {
            return Change.OVERFLOW;
        } else if (kind == StandardWatchEventKinds.ENTRY_DELETE) {
            return Change.DELETED;
        }
        return null;
    }

    public DirectoryWatcher watchFilesInBg() {
        new Thread(this::watchFiles).start();
        return this;
    }

    public enum Change {
        CREATED, MODIFIED, DELETED, OVERFLOW
    }
}
