package ak.eep.web.server.server;

import io.javalin.Javalin;
import io.javalin.staticfiles.Location;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.SortedSet;
import java.util.TreeSet;
import java.util.function.Supplier;

public class Server {
    private static Logger log = LoggerFactory.getLogger(Server.class);
    private final Javalin app;
    private SortedSet<String> urls = new TreeSet<>();
    private final WebsocketHandler websocketHandler = new WebsocketHandler();

    public Server(boolean testMode) {
        app = Javalin.create();
        // app.enableStaticFiles("C:\\Spiele\\Andreas_Kreuz\\ak-eep-web-server\\target\\classes\\public\\ak-eep-web",
        // Location.EXTERNAL)
        if (!testMode) {
            app.enableStaticFiles("/public/ak-eep-web", Location.CLASSPATH).enableSinglePageMode("/",
                    "/public/ak-eep-web/index.html");
        }
        if (testMode) {
            app.enableCorsForAllOrigins();
        }
        app.ws("/ws", ws -> {
            ws.onConnect(websocketHandler::onConnect);
            ws.onMessage(websocketHandler::onMessage);
            ws.onClose(websocketHandler::onClose);
            ws.onError(websocketHandler::onError);
        });
    }

    public void startServer() {
        app.start(3000);
        System.out.println("" + "   ___     ___      ___         __      __        _      \n"
                + "  | __|   | __|    | _ \\   ___  \\ \\    / / ___   | |__   \n"
                + "  | _|    | _|     |  _/  |___|  \\ \\/\\/ / / -_)  | '_ \\  \n"
                + "  |___|   |___|   _|_|_   _____   \\_/\\_/  \\___|  |_.__/  \n"
                + "_|\"\"\"\"\"|_|\"\"\"\"\"|_| \"\"\" |_|     |_|\"\"\"\"\"|_|\"\"\"\"\"|_|\"\"\"\"\"| \n"
                + "\"`-0-0-'\"`-0-0-'\"`-0-0-'\"`-0-0-'\"`-0-0-'\"`-0-0-'\"`-0-0-' ");
    }

    /**
     * @param url             Startet mit &quot;/&quot;, z.B. /signals
     * @param contentSupplier Supplier, der den Inhalt der URL bereitstellt
     */
    public void addServerUrl(String url, Supplier<String> contentSupplier) {
        log.info("Adding URL " + url);

        urls.add(url);
        app.get(url, ctx -> ctx.contentType("application/json").result(contentSupplier.get()));
    }

    public boolean urlUsed(String url) {
        return urls.contains(url);
    }

    public WebsocketHandler getWebsocketHandler() {
        return websocketHandler;
    }
}
