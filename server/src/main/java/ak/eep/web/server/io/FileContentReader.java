package ak.eep.web.server.io;

import org.jetbrains.annotations.NotNull;

import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;

/**
 * Read file contents
 */
public class FileContentReader {

    @NotNull
    public String readFileContentDefault(Path file) throws IOException {
        byte[] encoded = Files.readAllBytes(file);
        return new String(encoded, Charset.defaultCharset());
    }

    @NotNull
    public String readFileContentWin1252(Path file) throws IOException {
        byte[] encoded = Files.readAllBytes(file);
        return new String(encoded, EepDefaults.CHAR_SET);
    }
}
