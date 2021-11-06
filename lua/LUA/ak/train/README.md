# Züge

* `Train` Ein Zug, der aus mehreren Teilen (RollingStock) besteht. Kann auch ein einzelnes Fahrzeug sein.
  * `name`: `string` - Name des Zuges (Fahrzeugverbund)
  * `speed`: `number` - aktuelle Geschwindigkeit
  * `rollingStockCount`: `number` - Anzahl der Fahrzeuge im Zug
  * `route`: `string` - Route des Zuges
  * `trackType`: `string` - Typ der Spline, auf denen sich der Zug befindet (`"auxiliary"`, `"control"`, `"road"`, `"rail"`, `"tram"`)
  * `onTracks`: `table` Alle Tracks auf denen der Zug steht
  * `values`: `table` of all entries stored in the train

* `RollingStock` enthält alle Fahrzeuge
  