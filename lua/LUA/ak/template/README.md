---
layout: page_with_toc
title: Vorlagen für Dich
subtitle: Nutze die Vorlagen um schneller mit EEP-Web zu starten.
permalink: lua/ak/template/
feature-img: "/docs/assets/headers/SourceCode.png"
img: "/docs/assets/headers/SourceCode.png"
---

# Paket ak.template - Vorlagen für Dich

- `eep-web-main.lua` - kannst Du mit `require("ak.template.eep-web-main")` in jede Anlage einbinden, die noch kein Lua verwendet
- `crossing-simple.lua` - kannst Du verwenden um mit einer einfachen Ampelanlage zu starten

  1. Kopiere die Datei in das `LUA`-Verzeichnis von EEP
  2. Benenne die Datei um, z.B. in `anlage1.lua`
  3. Nutze im Lua-Editor von EEP die Zeile `require("anlage1")`
  4. Vervollständige die Datei mit Deinen Kreuzungsdaten

- `crossing-simple-test.lua` kannst Du verwenden um eine Anlage mit Kreuzung zu testen

  1. Kopiere die Datei in das `LUA`-Verzeichnis von EEP
  2. Benenne die Datei um, z.B. in `anlage1-test.lua`
  3. Ruf die zu testende Anlage mit `require` auf, z.B. `require("anlage1")`
