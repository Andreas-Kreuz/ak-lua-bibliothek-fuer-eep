package ak.eep.web.server.io;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.function.BiConsumer;

/**
 * Read log file and remember last known position.
 */
public class LogFileWatcher implements BiConsumer<Path, DirectoryWatcher.Change> {
    private static Logger log = LoggerFactory.getLogger(LogFileWatcher.class);

    private final Path logFile;
    private long lastPosition = 0L;
    private List<BiConsumer<String, Boolean>> logLineConsumers = new ArrayList<>();

    public LogFileWatcher(Path logFile) {
        this.logFile = logFile;
    }

    @Override
    public void accept(Path path, DirectoryWatcher.Change change) {
        if (!logFile.getFileName().equals(path.getFileName())) {
            log.error("NOT MATCHING: \n" + logFile.toFile().getAbsolutePath() + "\n" + path.toFile().getAbsolutePath());
        }

        try {
            String newLines = "";
            boolean reset = false;

            if (change == DirectoryWatcher.Change.CREATED
                    || (change == DirectoryWatcher.Change.MODIFIED && Files.size(logFile) < lastPosition)) {
                log.info("LOG CLEARED: " + logFile.toFile());
                lastPosition = 0L;
                reset = true;
            }

            if (logFile.toFile().isFile()) {
                final StringBuilder lines = new StringBuilder();
                final RandomAccessFile inputFile = new RandomAccessFile(logFile.toFile(), "r");
                inputFile.seek(lastPosition);
                int i = 0;
                String newLine;
                while ((newLine = inputFile.readLine()) != null) {
                    lines.append(newLine);
                    lines.append('\n');
                    i++;
                }
                if (i > 0) {
                    log.info(change + " --- Sending " + i + " lines at once.");
                    // lines.delete(lines.length() - 1, lines.length());
                    newLines = lines.toString();
                }
                lastPosition = inputFile.getFilePointer();
                inputFile.close();
            }
            final String fNewLines = newLines;
            final boolean fReset = reset;
            logLineConsumers.stream().forEach(c -> c.accept(fNewLines, fReset));
        } catch (IOException e) {
            log.debug("Could not read " + logFile, e);
        }
    }

    public void addLogLineConsumer(BiConsumer<String, Boolean> logLineConsumer) {
        this.logLineConsumers.add(logLineConsumer);
    }

    public String getAllCurrentLogLines() {
        StringBuilder lines = new StringBuilder();
        try {
            RandomAccessFile inputFile = new RandomAccessFile(logFile.toFile(), "rw");
            String newLine;
            while ((newLine = inputFile.readLine()) != null) {
                lines.append(newLine);
                lines.append('\n');
            }
            inputFile.close();
        } catch (IOException e) {
            log.debug("Could not read " + logFile, e);
        }
        return lines.toString();
    }
}
