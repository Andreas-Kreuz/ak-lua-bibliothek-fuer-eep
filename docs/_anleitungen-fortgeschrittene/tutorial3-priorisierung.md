---
layout: page_with_toc
title: Ampelsteuerung 3
type: Tutorial mit Anlage
subtitle: Erfahre wie Du anliegenden Verkehr erkennen kannst und wie dieser die Schaltungen beeinflusst.
img: "/assets/thumbnails/tutorial3-verkehr-erkennen.jpg"
permalink: anleitungen-fortgeschrittene/tutorial3-priorisierung
hide: false
date: 2017-09-03
---

# Priorisierung an der Ampel

**Voraussetzungen:**

- [Anleitung "Ampelkreuzung automatisch steuern"](ampelkreuzung) - fange hier an, um zu erfahren, was Kreuzung, Schaltung und Fahrspur bedeuten.

# Beispielanlage öffnen

- Lade und installiere Dir die Beispielanlagen für die Ampeln "Installer-AK-Tutorial-Ampelkreuzung.zip"
- Öffne die Beispielanlage "_Andreas_Kreuz_Tutorial_Ampelkreuzung-2.anl3_" in EEP
- Öffne die Datei `Andreas_Kreuz-Tutorial-Ampelkreuzung-2-main.lua` in einem Editor - Du findest sie unter `C:\Trend\EEP\LUA\ak\demo-anlagen\tutorial-ampel\`.

# So funktioniert Priorisierung

## ... innerhalb einer Fahrspur

Es gibt 4 Arten von Priorisierungen für Fahrspuren. Nur eine davon kann gleichzeitig verwendet werden:

<ul class="list-unstyled">
  <li class="media mt-5">
    <img class="img-thumbnail mr-3" src="{{ site.baseurl }}/assets/tutorial/tutorial3/erkennung-wartezeit.png" width="128" height="128" alt="Priorisierung nach Wartezeit">
    <div class="media-body">
      <h5 class="mt-0">Priorisierung nach Wartezeit</h5>
      Werden die Fahrzeuge nicht anhand von unten stehenden Mechanismen erkannt, so erfolgt die Priorisierung dieser Fahrspur anhand der Wartezeit. Die Wartezeit wird immer um eins hochgezählt, wenn diese Fahrspur beim Ändern der Ampelschaltung rot bekommt. Sie wird auf 0 zurükgesetzt, wenn die Ampel grün bekommt.<br><br>
      Wenn Du <strong>keine</strong> Priorisierung einrichtest, dann werden die Fahrspuren anhand ihrer Wartezeit geschaltet.
    </div>

  </li>
  <li class="media mt-5">
    <img class="img-thumbnail mr-3" src="{{ site.baseurl }}/assets/tutorial/tutorial3/erkennung-kontaktpunkt.png" width="128" height="128" alt="Zählen von Fahrzeugen">
    <div class="media-body">
      <h5 class="mt-0">Zählen von Fahrzeugen</h5>
      Wenn Du die Anzahl der Fahrzeuge einer Fahrspur mit Kontaktpunkten zählst, bekommst Du die bestmögliche Erkennung für mehrere Fahrzeuge.<br><br>
      Setze für jeder Fahrspur zwei Kontaktpunkte: Den ersten vor der Ampel, der der Fahrspur sagt, dass sich ein weiteres Fahrzeug vor der Ampel befindet. Den zweiten nach der Ampel, der der Fahrspur sagt, dass sich ein Fahrzeug weniger an der Ampel befindet.
    </div>

  </li>
  <li class="media mt-5">
    <img class="img-thumbnail mr-3" src="{{ site.baseurl }}/assets/tutorial/tutorial3/erkennung-signal.png" width="128" height="128" alt="Erkennen von Fahrzeugen am roten Signal">
    <div class="media-body">
      <h5 class="mt-0">Erkennen von Fahrzeugen am roten Signal  (nicht empfohlen)</h5>
      Du kannst den Verkehr einer Fahrspur erkennen, wenn sie an einer roten Ampel stehen. Die Funktion erkennt Fahrzeuge, die <strong>zwischen dem Vor- und Hauptsignal einer roten Ampel</strong> stehen - intern wird regelmäßig <code>EEPGetSignalTrainsCount</code> abgefragt.<br>
      Diese Variante wird nicht empfohlen, weil die Fahrzeuge nur zwischen Vor- und Hauptsignal gezählt werden. Ist dieser Abstand zu kurz, werden nicht genügend Fahrzeuge gezählt, ist er zu lang, fahren zu viele Fahrzeuge nach dem Schalten auf rot durch.
    </div>
  </li>
  <li class="media mt-5">
    <img class="img-thumbnail mr-3" src="{{ site.baseurl }}/assets/tutorial/tutorial3/erkennung-strasse.png" width="128" height="128" alt="Erkennen von Fahrzeugen auf Straße">
    <div class="media-body">
      <h5 class="mt-0">Erkennen von Fahrzeugen auf Straße (nicht empfohlen)</h5>
      Du kannst die Ampelschaltung einer Fahrspur priorisieren, indem Du prüfst, ob auf dem Straßenstück vor der Ampel ein Fahrzeug steht - intern wird dazu <code>EEPRegisterRoadTrack</code> verwendet.<br>
      Diese Variante wird nicht empfohlen, weil sie nicht mehrere Fahrzeuge auf einem Straßenstück erkennt und daher die anstehende Fahrzeugschlange nicht korrekt ist.
    </div>
  </li>
</ul>

⭐ **Bitte beachte**: Pro Fahrspur kann nur ein Mechanismus verwendet werden. Bei mehreren Mechanismen, gewinnt der erste in der folgenden Liste:

1. Erkennen von Fahrzeugen auf Straßen
2. Erkennen von Fahrzeugen an Signalen
3. Zählen mit Kontaktpunkten
4. Automatisch anhand der Wartezeit

## ... innerhalb einer Kreuzung

Die nächste Schaltung wird immer durch die höchsten Durchschnittspriorität aller Fahrspuren bestimmt.

Durch das Einbeziehen der Wartezeit wird sichergestellt, dass jede Fahrspur berücksichtigt wird.

⭐ Am besten verwendest Du die Priorisierung für alle Fahrspuren einer Kreuzung - oder für gar keine.

# Erkennung mit Strassen (nicht empfohlen)

![]({{ site.baseurl }}/assets/tutorial/tutorial3/reservierung-strasse.jpg)

<div class="media mb-5">
  <img class="img-thumbnail mr-3" src="{{ site.baseurl }}/assets/tutorial/tutorial3/erkennung-strasse.png" width="128" height="128" alt="Priorisierung nach Wartezeit">
  <div class="media-body">
    Erkenne eine belegte Fahrspur daran, ob sich ein Fahrzeug auf dem Straßenstück vor dem Signal befindet.
  </div>
</div>

- Verwende dazu folgenden Code (`lane` ist eine Fahrspur):

  ```lua
  local laneSignal1 = TrafficLight:new("LANE WS", 15, TrafficLightModel.Unsichtbar_2er)
  lane = Lane:new("WS", 108, laneSignal1)
  lane:useTracklForQueue(2) -- Erfasst Anforderungen, wenn ein Fahrzeug auf Strasse 2 steht
  ```

- Die Code-Zeile `ws:zaehleAnStrasseAlle(xx)` sorgt dafür, dass die Fahrspur priorisiert wird, wenn das Straßenstück mit der ID `xx` belegt ist. Dies erfolgt jedoch immer nur für ein Fahrzeug pro Straßenstück.

- Es können auch mehrere Straßenstücke gleichzeitig beobachtet werden, z.B. für mehrspurige Straßen.

  ```lua
  ws:useTracklForQueue(2)
  ws:useTracklForQueue(3)
  ```

- Insgesamt werden alle belegten Straßenstück der Fahrspur als ein Fahrzeug gezählt.

# Erkennung mit Signalen (nicht empfohlen)

![]({{ site.baseurl }}/assets/tutorial/tutorial3/reservierung-signal.jpg)

<div class="media mb-5">
  <img class="img-thumbnail mr-3" src="{{ site.baseurl }}/assets/tutorial/tutorial3/erkennung-signal.png" width="128" height="128" alt="Priorisierung nach Wartezeit">
  <div class="media-body">
    Erkenne eine belegte Fahrspur anhand der Fahrzeuge die am <strong>roten</strong> Signal warten.
  </div>
</div>

Die Erkennung erfolgt ähnlich wie bei der Straße (Details siehe oben).

```lua
lane:useSignalForQueue()
```

⭐ Die Erkennung funktioniert nur, wenn die Ampel rot ist.

# Erkennung mit Kontaktpunkten (empfohlen)

![]({{ site.baseurl }}/assets/tutorial/tutorial3/reservierung-zaehler.jpg)

<div class="media mb-5">
  <img class="img-thumbnail mr-3" src="{{ site.baseurl }}/assets/tutorial/tutorial3/erkennung-kontaktpunkt.png" width="128" height="128" alt="Priorisierung nach Wartezeit">
  <div class="media-body">
    Wenn Du die Anzahl der Fahrzeuge einer Fahrspur mit Kontaktpunkten zählst, bekommst Du die bestmögliche Erkennung für mehrere Fahrzeuge.
  </div>
</div>

Setze für jeder Fahrspur zwei Kontaktpunkte:

1. Vor dem Signal der Fahrspur

   Dieser Kontaktpunkt muss die Funktion `lane:vehicleEntered(vehicleName)` aufrufen - in der Demo-Anlage wird in den Kontaktpunkten `enterLane(lane)` verwendet.

   ⭐ Achte darauf, dass nur Fahrzeuge den Kontaktpunkt aufrufen, die diese Fahrspur betreten.<br>
   ⭐ Achte darauf, dass der Kontaktpunkt nicht vor einer Verzweigungen liegt, die die Fahrzeuge auf andere Fahrspuren verteilt.

2. Hinter dem Signal der Fahrspur

   Dieser Kontaktpunkt muss die Funktion `lane:vehicleLeft(vehicleName)` aufrufen - in der Demo-Anlage wird in den Kontaktpunkten `leaveLane(lane)` verwendet.

   ⭐ Achte darauf, dass nur Fahrzeuge den Kontaktpunkt aufrufen, die die korrekte Fahrspur verlassen.<br>
   ⭐ Achte darauf, dass der Kontaktpunkt hinter der Haltelinie liegt.

Es ist notwendig, dass der Zugname in den Funktionen genutzt wird

```lua
------------------------------------------------
-- Damit kommt wird die Variable "Zugname" automatisch durch EEP belegt
-- http://emaps-eep.de/lua/code-schnipsel
------------------------------------------------
setmetatable(_ENV, {
    __index = function(_, k)
        local p = load(k)
        if p then
            local f = function(z)
                local s = Zugname
                Zugname = z
                p()
                Zugname = s
            end
            _ENV[k] = f
            return f
        end
        return nil
    end
})
```
