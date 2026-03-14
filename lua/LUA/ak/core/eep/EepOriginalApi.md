# Hinweise für KI-Agenten zum parsen von EepOriginalApi.d.lua aus dem Handbuch

Das Lua_Manual.pdf scheint wie folgt aufgebaut zu sein:

## Variablen

Es gibt pro Variable eine Tabelle mit drei Spalten und folgenden Zeilen:
1: "EEPVariable" (dynamischer Text über zwei Spalten) | EEPVariable (wiederholt)
2: "Voraussetzung" | Anzahl der Parameter | Beispielaufruf
3: "Zweck" | Beschreibung der Variable (über zwei Zeilen)

## Funktionen

Es gibt pro Funktion eine Tabelle mit drei Spalten und folgenden Zeilen:
1: EEPFunktion() (dynamischer Text über zwei Spalten) | Signaturbeispiel eine oder mehrere Zeilen
2: "Parameter" | Anzahl der Parameter | Beispielblock Teil 1
3: "Rückgabewerte" | Anzahl der Rückgabewerte | Beispielblock Teil 2
4: "Voraussetzung" | Mindestversion von Version / Plugin | Beispielblock Teil 3
5: "Zweck" | Beschreibung der Funktion für LuaDoc (über zwei Spalten)
6: "Bemerkungen" | Auflistung / Beschreibung der Parameter und Rückgabewerte (über zwei Spalten)

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
- Abhängig vom Feld können Spalte 2 und 3 auch zu einem gemeinsamen semantischen Feld zusammengehören.

## Farbplätze

Die folgenden Farbnamen sind Platzhalter für lokal erkannte PDF-Farbflächen:

- `[FARBE_KOPF_LINKS]`
- `[FARBE_KOPF_RECHTS]`
- `[FARBE_TITEL_LINKS]`
- `[FARBE_PARAMETER]`
- `[FARBE_RÜCKGABEWERTE]`
- `[FARBE_VORAUSSETZUNGEN]`
- `[FARBE_BEISPIELBLOCK]`
- `[FARBE_ZWECK]`
- `[FARBE_TITEL_BEMERKUNGEN]`
- `[FARBE_BEMERKUNGEN]`

Bekannte Gleichheiten im Layout:

- `FARBE_BEISPIELBLOCK` ist weiß.
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

[FARBE_TITEL_LINKS]        | [FARBE_RÜCKGABEWERTE]        | [FARBE_BEISPIELBLOCK]
Rückgabewerte              | Anzahl der Rückgabewerte     | Beispielblock Teil 2

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

- Spalte 1 und Spalte 2 zusammen: Funktionsname: EEPFunktion()
- Spalte 3: Signaturbeispiel

Regeln Funktionsname:

- Es beginnt fast immer mit `EEP`, sonst mit `print` oder `clearlog`.
- Bei Funktionen endet er immer mit ()

Regeln Signaturbeispiel:

- Das Signaturbeispiel ist ein Funktionsaufruf.
- Es beginnt fast immer mit `EEP`, sonst mit `print` oder `clearlog`.
- Es endet mit einer schließenden `)`.
- Es kann ein- oder mehrzeilig sein.
- Mehrere Kopfzeilen vor `Parameter` können deshalb noch zum selben Signaturbeispiel gehören.

## Beispielblock

Der Beispielblock in Spalte 3 ist kein Satz aus drei getrennten Einzelzellen, sondern typischerweise ein zusammenhängender Lua-Code Block.

Das Feld erstreckt sich über die Zeilen, kann aber weniger oder mehr Zeilen haben.

1. `Parameter`
2. `Rückgabewerte`
3. `Voraussetzung`

Regeln:

- Alle Texte in dieser verbundenen weißen Zelle gehören zum Beispielcode.
- Zeilenumbrüche in dieser Zelle bedeuten nicht automatisch eine semantische Trennung.
- Beispielcode darf deshalb über Feldgrenzen hinweg zusammengesetzt werden.

## Zweck

`Zweck` ist ein eigenes Textfeld und kein Beispielbereich.

Layout-Regeln:

- Das Label `Zweck` steht in Spalte 1.
- Der zugehörige Inhalt verwendet `[FARBE_ZWECK]`.
- Das Feld kann sich über Spalte 2 und Spalte 3 erstrecken.
- Alle Teile des Feldes behalten dieselbe Farbe.

Semantische Regel:

- `Zweck` enthält keine Bulletpoints.
- Beginnt dort ein Bullet, gehört dieser semantisch bereits zu `Bemerkungen`.

## Bemerkungen

`Bemerkungen` ist ein eigener Feldblock unterhalb von `Zweck`.

Layout-Regeln:

- Das Label `Bemerkungen` steht in Spalte 1.
- Das Label ist vertikal oben am Feldanfang ausgerichtet.
- Der Inhaltsbereich rechts davon verwendet `[FARBE_BEMERKUNGEN]`.
- Das Feld kann sich über Spalte 2 und Spalte 3 erstrecken.

Semantische Regel:

- `Bemerkungen` enthält häufig Bulletpoints.
- Parameter- und Rückgabesemantik wird inhaltlich vor allem aus diesem Feld gewonnen.

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

## Layout-Regeln für den Parser

Aus dem Aufbau folgen diese Regeln für die Extraktion:

1. Tabellenbreiten und Spaltengrenzen werden lokal pro Block aus Farbflächen und Textpositionen abgeleitet.
2. Gleiche Farbe über mehrere Teilzellen bedeutet: gleicher semantischer Feldverbund.
3. Der Kopfbereich wird getrennt von den Feldzeilen ausgewertet.
4. Das Signaturbeispiel in Spalte 3 darf mehrzeilig sein und wird bis zur schließenden `)` zusammengesetzt.
5. Der weiße Beispielblock in Spalte 3 über `Parameter`, `Rückgabewerte` und `Voraussetzung` wird als zusammenhängende Zelle behandelt.
6. `Zweck` wird aus dem linken und mittleren Tabellenbereich gelesen, nicht als Beispielcode.
7. `Bemerkungen` wird als eigener Block mit eigener Farbe und eigener Feldlogik behandelt.
