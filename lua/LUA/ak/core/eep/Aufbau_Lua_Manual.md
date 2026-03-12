# Aufbau Lua Manual

Dieses Dokument beschreibt nur den layout-spezifischen Aufbau der API-Tabellen in `Lua_manual.pdf`.
Im Fokus stehen Farbflächen, Spalten, verbundene Zellen und die semantische Zuordnung der Felder.

## Grundannahmen

- Jede API wird als eigener Tabellenblock dargestellt.
- Die Spaltenbreiten sind nicht global fest, sondern pro Tabelle unterschiedlich.
- Spalten und zusammengehörige Felder werden deshalb lokal über Farbflächen und Textpositionen erkannt.
- Wenn sich ein semantisches Feld über mehrere Zeilen oder mehrere Zellenanteile erstreckt, behalten alle Teile dieselbe Farbe.

## Drei Tabellenbereiche

Jeder Funktions- oder Callback-Block besteht layout-seitig aus drei vertikalen Bereichen:

1. Spalte 1: linker Titel- und Labelbereich
2. Spalte 2: mittlerer Inhaltsbereich
3. Spalte 3: rechter Beispielbereich

Wichtig:

- Spalte 1 und 2 bilden im Kopf gemeinsam den linken Kopfbereich.
- Spalte 3 ist im Kopf der rechte Kopfbereich.
- Abhaengig vom Feld koennen Spalte 2 und 3 auch zu einem gemeinsamen semantischen Feld zusammengehoeren.

## Farbplaetze

Die folgenden Farbnamen sind Platzhalter fuer lokal erkannte PDF-Farbflächen:

- `[FARBE_KOPF_LINKS]`
- `[FARBE_KOPF_RECHTS]`
- `[FARBE_TITEL_LINKS]`
- `[FARBE_PARAMETER]`
- `[FARBE_RUECKGABEWERTE]`
- `[FARBE_VORAUSSETZUNGEN]`
- `[FARBE_BEISPIELBLOCK]`
- `[FARBE_ZWECK]`
- `[FARBE_TITEL_BEMERKUNGEN]`
- `[FARBE_BEMERKUNGEN]`

Bekannte Gleichheiten im Layout:

- `FARBE_BEISPIELBLOCK` ist weiss.
- `FARBE_KOPF_RECHTS = FARBE_PARAMETER = FARBE_VORAUSSETZUNGEN`

## Funktions- oder Callback-Block

```text
Spalte 1                   | Spalte 2                     | Spalte 3
---------------------------|------------------------------|-----------------------------
[FARBE_KOPF_LINKS]         | [FARBE_KOPF_LINKS]           | [FARBE_KOPF_RECHTS]
EEPFunktion() Teil 1       | EEPFunktion() Teil 2         | Signaturbeispiel Teil 1
                           |                              | Signaturbeispiel Teil 2
                           |                              | Signaturbeispiel Teil N

[FARBE_TITEL_LINKS]        | [FARBE_PARAMETER]            | [FARBE_BEISPIELBLOCK]
Parameter                  | Anzahl der Parameter         | Beispielblock Teil 1

[FARBE_TITEL_LINKS]        | [FARBE_RUECKGABEWERTE]       | [FARBE_BEISPIELBLOCK]
Rueckgabewerte             | Anzahl der Rueckgabewerte    | Beispielblock Teil 2

[FARBE_TITEL_LINKS]        | [FARBE_VORAUSSETZUNGEN]      | [FARBE_BEISPIELBLOCK]
Voraussetzung              | Version / Plugin             | Beispielblock Teil 3

[FARBE_TITEL_LINKS]        | [FARBE_ZWECK]                | [FARBE_ZWECK]
Zweck                      | Zwecktext Teil 1             | Zwecktext Teil 2

[FARBE_TITEL_BEMERKUNGEN]  | [FARBE_BEMERKUNGEN]          | [FARBE_BEMERKUNGEN]
Bemerkungen                | Bemerkungstext Teil 1        | Bemerkungstext Teil 2
```

## Kopfbereich

Der Kopfbereich ist der oberste Tabellenabschnitt eines Funktionsblocks.

Semantische Zuordnung:

- Spalte 1 und Spalte 2 zusammen: Funktionsname
- Spalte 3: Signaturbeispiel

Regeln:

- Das Signaturbeispiel ist ein Funktionsaufruf.
- Es beginnt fast immer mit `EEP`, sonst mit `print` oder `clearlog`.
- Es endet mit einer schliessenden `)`.
- Es kann ein- oder mehrzeilig sein.
- Mehrere Kopfzeilen vor `Parameter` koennen deshalb noch zum selben Signaturbeispiel gehoeren.

## Beispielblock

Der Beispielblock in Spalte 3 ist kein Satz aus drei getrennten Einzelzellen, sondern typischerweise ein zusammenhaengender vertikaler Feldverbund.

Er erstreckt sich ueber die Zeilen:

1. `Parameter`
2. `Rueckgabewerte`
3. `Voraussetzung`

Regeln:

- Alle Texte in dieser verbundenen weissen Zelle gehoeren zum Beispielcode.
- Zeilenumbrueche in dieser Zelle bedeuten nicht automatisch eine semantische Trennung.
- Beispielcode darf deshalb ueber Feldgrenzen hinweg zusammengesetzt werden.

## Zweck

`Zweck` ist ein eigenes Textfeld und kein Beispielbereich.

Layout-Regeln:

- Das Label `Zweck` steht in Spalte 1.
- Der zugehoerige Inhalt verwendet `[FARBE_ZWECK]`.
- Das Feld kann sich ueber Spalte 2 und Spalte 3 erstrecken.
- Alle Teile des Feldes behalten dieselbe Farbe.

Semantische Regel:

- `Zweck` enthaelt keine Bulletpoints.
- Beginnt dort ein Bullet, gehoert dieser semantisch bereits zu `Bemerkungen`.

## Bemerkungen

`Bemerkungen` ist ein eigener Feldblock unterhalb von `Zweck`.

Layout-Regeln:

- Das Label `Bemerkungen` steht in Spalte 1.
- Das Label ist vertikal oben am Feldanfang ausgerichtet.
- Der Inhaltsbereich rechts davon verwendet `[FARBE_BEMERKUNGEN]`.
- Das Feld kann sich ueber Spalte 2 und Spalte 3 erstrecken.

Semantische Regel:

- `Bemerkungen` enthaelt haeufig Bulletpoints.
- Parameter- und Rueckgabesemantik wird inhaltlich vor allem aus diesem Feld gewonnen.

## Variable-Block

Auch Variablen stehen in Tabellenform, aber mit reduzierter Feldstruktur.

```text
Spalte 1                   | Spalte 2                     | Spalte 3
---------------------------|------------------------------|-----------------------------
[FARBE_KOPF_LINKS]         | [FARBE_KOPF_LINKS]           | [FARBE_KOPF_RECHTS]
Variablenname Teil 1       | Variablenname Teil 2 / leer  | Beispiel / Wiederholung

[FARBE_TITEL_LINKS]        | [FARBE_VORAUSSETZUNGEN]      | [FARBE_VORAUSSETZUNGEN]
Voraussetzung              | Version / Plugin             | optionaler Beispieltext

[FARBE_TITEL_LINKS]        | [FARBE_ZWECK]                | [FARBE_ZWECK]
Zweck                      | Zwecktext Teil 1             | Zwecktext Teil 2
```

## Layout-Regeln fuer den Parser

Aus dem Aufbau folgen diese Regeln fuer die Extraktion:

1. Tabellenbreiten und Spaltengrenzen werden lokal pro Block aus Farbflächen und Textpositionen abgeleitet.
2. Gleiche Farbe ueber mehrere Teilzellen bedeutet: gleicher semantischer Feldverbund.
3. Der Kopfbereich wird getrennt von den Feldzeilen ausgewertet.
4. Das Signaturbeispiel in Spalte 3 darf mehrzeilig sein und wird bis zur schliessenden `)` zusammengesetzt.
5. Der weisse Beispielblock in Spalte 3 ueber `Parameter`, `Rueckgabewerte` und `Voraussetzung` wird als zusammenhaengende Zelle behandelt.
6. `Zweck` wird aus dem linken und mittleren Tabellenbereich gelesen, nicht als Beispielcode.
7. `Bemerkungen` wird als eigener Block mit eigener Farbe und eigener Feldlogik behandelt.
