# json-data Observer

Dieser Observer wandelt die von EEP gesammelten Daten 1:1 in JSON-Daten um und stellt diese bereit.

ℹ Je nach geladenem Lua-Modul gibt es mehr oder weniger Einträge.

## Bereitgestellte Daten

- **`/api-entries`** enthält alle Einträge über die bekannten EEP-Daten.
  Dies ist ein zusätzlicher Knoten, der vom Server erzeugt wird und eine Übersicht über die API-Einträge enthält.

- **`/xxx`** enthält den Key der eigentlichen von EEP eingesammelten Einträge, z.B. `structures` oder `signals`. Der Inhalt hängt vom geladenen Lua-Modul ab.

- Der öffentliche Lua-Vertrag für diese Räume ist aktuell in den bereichsspezifischen Dateien `lua/LUA/ce/hub/data/**/*DtoTypes.d.lua` und `lua/LUA/ce/hub/data/**/*DtoTypes.d.md` dokumentiert.
  Diese Dateien werden vom Server derzeit noch nicht zur Laufzeit eingelesen, sind aber die Soll-Quelle für Room-Namen, `keyId` und DTO-Formen.

### Zugriff über API

Die API wird auf dem Webserver unter `/api/v1/` bereitgestellt.

**Bitte beachten:** Die API ist noch nicht versioniert. Auch bei Änderungen wird hier `v1` angezeigt.

### Zugriff über socket.io

Der Zugriff über socket.io kann durch die Registrierung an den Datenräumen erfolgen. Bei jedem Update werden die Daten automatisch an diese Räume gesendet.

Um über Änderungen an Daten informiert zu werden, kann man sich an dem jeweiligen Raum **`[Data 'xxx']`** anmelden:

```typescript
// Raum betreten - für Daten vom Typ xxx
socket.emit('[Room] Join', { "[Data 'xxx']" });

// Raum verlassen - für Daten vom Typ xxx
socket.emit('[Room] Leave', { "[Data 'xxx']" });
```
