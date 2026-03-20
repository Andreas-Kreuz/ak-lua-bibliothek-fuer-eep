# Daten Sammlung

## Züge

Als Züge werden alle Fahrzeugverbände in EEP bezeichnet. Ein Fahrzeugverband besteht aus mehreren Rollmaterialien.

### Erkennung neuer Züge

- Neue oder bekannte Züge werden wie folgt erkannt:

  - Erkennung durch Belegung eines Streckenabschnitts mit `EEPIs...TrackReserved`
  - Erkennung beim Verlassen eines Depots mittels `EEPOnTrainExitTrainyard`

- Die folgenden Züge können neu oder bereits bekannt sein, müssen aber garantiert aktualsisiert werden:

  - Erkennung beim Entkoppeln `EEPOnTrainLooseCoupling`
  - Erkennung beim Ankoppeln `EEPOnTrainCoupling`

### Aktualisierung von Zügen

1. Alle Einstellungen inklusive Rollmaterial aktualisieren

   - Entfernte Züge müssen entfernt werden (inkl. deren Rollmaterial)
   - Aktualisiert werden müssen:
     - Neue Züge
     - Züge, die durch ankoppeln oder entkoppeln neu zusammengestellt wurden

2. Bekannte Züge müssen aktualisiert werden, wenn sie ihre Position geändert haben

   - Züge, die sich bewegt haben

Folgende Zugeigenschaften werden aktualisiert:

- bei Erkennung / Neuzusammenstellung (dirtyTrain)
  - Alle Eigenschaften inklusive aller `RollingStock` Elemente des Zuges
- bei Bewegung (movedTrain)
  - Belegte Gleise
  - Geschwindigkeiten
  - Routen
