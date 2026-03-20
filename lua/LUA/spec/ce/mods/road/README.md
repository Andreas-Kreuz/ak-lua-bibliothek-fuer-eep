# Ampelkreuzung

Jede Ampelkreuzung besteht aus Fahrspuren und Fußgängerfurten.
Ampeln regeln welche Fahrzeuge fahren und welche Fußgänger gehen dürfen.

## Begriffe

- **Ampel** / **Traffic Light**:

  _Eine Ampel regelt, wer fahren darf und kann rot, gelb oder grün sein. Eine Kreuzungsschaltung legt fest, welche Ampeln gleichzeitig grün sein dürfen. Für eine bestimmte **Fahrspur** / **Lane** können mehrere unterschiedliche Ampeln gelten. Ampeln können auch für mehrere Fahrspuren gelten._

  _Jede Ampel gilt für eine bestimmte **Richtung**, z.B. nur für Links. Alle Ampeln, die an einer ankommenden Straße für die selbe Richtung gelten, müssen gleichzeitig geschaltet werden, d.h. alle Linksabbieger-Ampel gleichzeitig._

  _An jeder einzelnen Ampelkreuzung in Dresden werden die einzelnen Ampeln wie folgt markiert: Es gibt es eine Markierung aus Buchstaben ("B" für Bus, "K" für Kraftverkehr, "S" für Straßenbahn, "F" für Fußgänger) und Zahl 1 .. n. Ampeln können an diesen Markierungen F1, F2, ..., K1, K2, ... unterschieden werden._

- **Fahrspur** / **Lane**:

  _In einer Fahrspur stellen sich hintereinander mehrere Fahrzeuge in einer Schlange an der Ampelkreuzung an._

  _Jede Fahrspur hat eine Fahrspur-Ampel, an der sich die Fahrzeuge anstellen. Dies ist die einzige Ampel, die den Verkehr der Fahrspur steuert._

  _Jede Fahrspur hat mindestens eine **Richtung**, in der sie in einer gegenüberliegenden oder abbiegenden Straße mündet, z.B. Geradeaus, Rechts, Links._

  _Im einfachen Fall gilt eine Ampel für alle Richtungen einer Fahrspur. Eine Fahrspur kann durch unterschiedliche **Ampeln** für mehrere **Richtungen** gesteuert werden, die dann nur für solche Fahrzeuge gelten, die in bestimmte Richtungen wollen. Das erste Fahrzeug in einer Fahrsprur kann fahren, wenn die für das Fahrzeug passende Ampel grün geschaltet wurde._

- **Fußgängerampel** / **Pedestrian Light**:

  _Eine Fußgängerampel regelt, ob ein Fußgänger die Straße überqueren darf und kann rot oder grün sein. Eine Kreuzungsschaltung legt fest, welche Fußgängerampeln gleichzeitig mit anderen Ampeln grün sein dürfen._

- **Fußgängerfurt** / **Pedestrian Crossing**:

  _Fußgänger dürfen Kreuzungen nur an einer Fußgängerfurt überqueren. Dies wird durch Fußgängerampeln geregelt._

- **Kreuzung** / **Crossing**

  _An einer Kreuzung treffen mindestens zwei Straßen aufeinander. An einer Ampelkreuzung werden verschiedene Schaltungen genutzt, um den Verkehr zu steuern. Die Schaltungen folgen entweder nach Zeit aufeinander oder anhand des Verkehrsaufkommens. Eine Nachtschaltung kann optional eingeschaltet werden._

- **Schaltung** / **Circuit**

  _Eine Schaltung ermöglicht das gleichzeitige Schalten mehrerer Ampeln für Fahrspuren und Fußgänderfurten. Dabei müssen zusammengehörende Richtungsampeln gleichzeitig geschaltet werden._

  _Eine Schaltung kann auch alle Ampeln einer Kreuzung für den Nachtbetrieb ausschalten oder gelb blinken lassen._

## Ampelkreuzung in EEP

## Fahrspur in EEP

Jede Fahrspur hat genau ein Signal, dass den Verkehr der Fahrspur steuert. Im einfachsten Fall ist das die Ampel, die den Verkehr für alle Richtungen steuert.
Werden zusätzliche Ampeln genutzt, dann dürfen diese keinesfalls auf der selben Fahrspur stehen, da sonst die Steuerung nicht funktioniert. Stattdessen müssen diese auf der Gegenfahrbahn oder einer unsichtbaren Straße plaziert werden.

Die Fahrzeuge eine Fahrspur können erkannt werden durch:

- Zählen mit Kontaktpunkten (empfohlen)
- Zählen am Signal - es wird das Signal der Fahrspur verwendet
- Belegung der Straße

### Fahrspuren mit mehreren Ampeln

Der Verkehr einer Fahrspur kann durch mehrere Ampeln gesteuert werden:

- Neben der normalen Ampel gibt es eine Zusatz-Ampel nur für Rechtsabbieger
- Auf einer Fahrspur für Straßenbahnen gibt es eine Ampel für linksabbiegende und eine Ampel für
  geradeausfahrende Straßenbahnen

Gelten mehrere Ampeln unterschiedlicher Richtungen für eine Fahrspur, dann muss die Fahrspur-Ampel ein unsichtbares Signal sein.

In dem Fall darf das erste Fahrzeug immer dann Fahren, wenn eine für das Fahrzeug geltende Ampel grün anzeigt. Die Steuerung muss deshalb wissen, welche Ampel für das erste Fahrzeug gilt. Für die Erkennung welche der Ampeln für ein Fahrzeug gilt, kann die **Route** des Fahrzeugs genutzt werden. (_Geplant ist auch eine Erkennung anhand der Tags des ersten Fahrzeugs eines Zuges._)

## Ampeln in EEP

Eine Ampeln kann für mehrere Fahrspuren gelten

- für die komplette Fahrspur (alle Fahrzeuge können fahren) ODER
- für einzelne Fahrzeuge der Fahrspur (nur wenn )

Eine Ampel kann geschaltet werden, wenn

- aktiv (wenn Anforderungen vorliegen, oder nach Zeit)
- nur nach Anforderung durch bestimmte Fahrzeuge
- passiv (wenn sie in einer anderen Schaltung vorkommt)
