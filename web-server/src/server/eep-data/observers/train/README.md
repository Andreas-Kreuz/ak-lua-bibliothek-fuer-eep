# Train Observer

Dieser Observer wandelt die von EEP gesammelten Daten in folgende Dinge um:

- `TrainListEntry[]` eine Liste von Einträgen, die als Züge dargestellt werden sollen.

  ```typescript

  // Raum betreten - für Züge vom Typ xxx
  // xxx ist auxiliary | control | rail | road | tram
  socket.emit('[Room] Join', { "[Train List 'xxx']" });
  ```

- `Train` Daten eines Zuges für die Detail-Darstellung

  ```typescript
  // Raum betreten - für Zug xxx (Name wie in EEP mit #)
  socket.emit('[Room] Join', { '[Train Details "xxx"]' });
  ```

ℹ Die Daten sind nur verfügbar, wenn das Modul für Züge geladen ist.

ℹ Die Daten werden nur erstellt, wenn jemand am entsprechenden Raum angemeldet ist.
