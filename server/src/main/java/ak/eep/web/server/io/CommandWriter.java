package ak.eep.web.server.io;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.file.Path;

/**
 * Write commands for EEP to a file.
 */
public class CommandWriter {
    private static Logger log = LoggerFactory.getLogger(CommandWriter.class);

    private final Path commandFile;

    public CommandWriter(Path commandFile) {
        this.commandFile = commandFile;
    }

    public void writeCommand(String command) {
        try {
            log.info("Writing: " + command);
            RandomAccessFile readWriteFileAccess = new RandomAccessFile(commandFile.toFile(), "rw");
            readWriteFileAccess.seek(readWriteFileAccess.length());
            readWriteFileAccess.write((command + "\n").getBytes(EepDefaults.CHAR_SET));
            readWriteFileAccess.close();
        } catch (IOException e) {
            log.debug("Could not read " + commandFile, e);
        }
    }
}
