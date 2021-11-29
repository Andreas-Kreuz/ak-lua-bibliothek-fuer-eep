# EEP-Event API

Dieses Modul nimmt die Daten von EEP entgegen.

## Initialisierung und Caching

Die Lua-Bibliothek erzeugt in jedem Zyklus neue Daten und sendet die Aktualisierungen an den Server,
falls dieser läuft und bereit ist. Der Server nimmt die Daten entgegen.

Der jeweils aktuelle Zustand dieser Daten (`State`) wird in einem Cache abgelegt.

Dann sorgen verschiedene StateObserver dafür, dass der von EEP gemeldete Zustand an die registrierten Clients
weitergeleitet wird.

Der Server jederzeit beendet und wieder neu gestartet werden. So lange wird EEP keine weiteren Änderungen senden.
Durch den Cache kann der Server kann einem Neustart da weitermachen, wo er war.

Wird EEP neu gestartet, wird der aktuelle Zustand der Daten (`State`) im Server zurückgesetzt.
Dies geschieht auch, wenn in EEP das Lua-Skript neu geladen wird.

## Datenfluss

```txt
                 check for
                  changes
               ┌───────────┐
               │           │
               │           ▼

┌───────────────┐         ┌────────────────┐
│               │         │                │
│ JSON Reducer  │         │ State Observer │
│               │         │                │
└───────────────┘         └────────────────┘

               ▲           │
 Keep last     │           │ Publish data
 data in state │           │ to rooms
               │           ▼

┌───────────────┐         ┌────────────────┐
│               │         │                │
│ JSON Effects  │         │  Data Rooms    │
│               │         │                │
└───────────────┘         └────────────────┘

               ▲           │
 JSON Data     │           │ Send room data
 via files     │           │ via socket.io
               │           ▼

┌───────────────┐         ┌────────────────┐
│               │         │                │
│    EEP-Lua    │         │    Web-App     │
│               │         │                │
└───────────────┘         └────────────────┘
```
