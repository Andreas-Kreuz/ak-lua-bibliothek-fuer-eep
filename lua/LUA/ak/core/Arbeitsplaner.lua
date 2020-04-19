print("Lade ak.eep.Arbeitsplaner ...")
local Arbeitsplaner = {}

local AkStatistik = require("ak.io.AkStatistik")
local enableServer = false
local initialisierungErfolgt = false
local registrierteArbeiter = {}

---
-- Registers a arbeiter to be used in EEP Web
-- @param arbeiter a arbeiter of type AkLuaControlModule
function Arbeitsplaner.meldeArbeiterAn(...)
    assert(not initialisierungErfolgt, "Ein Modul darf nicht Arbeitsplaner.initialisiereArbeiter() aufgerufen werden")

    for _, arbeiter in ipairs({...}) do
        -- Check the arbeiter
        assert(
            arbeiter.name and type(arbeiter.name) ~= "string",
            "Der Name des Moduls muss gesetzt und ein String sein"
        )
        assert(
            arbeiter.initialisieren and type(arbeiter.initialisieren) ~= "function",
            "Das Modul muss eine Funktion initialisieren() besitzen"
        )
        assert(
            arbeiter.arbeiten and type(arbeiter.arbeiten) ~= "function",
            "Das Modul muss eine Funktion arbeiten() besitzen"
        )

        -- Remember the arbeiter by it's name
        registrierteArbeiter[arbeiter.name] = arbeiter
    end
end

---
-- Registers a arbeiter to be used in EEP Web
-- @param arbeiter a arbeiter of type AkLuaControlModule
function Arbeitsplaner.meldeArbeiterAb(...)
    for _, arbeiter in ipairs({...}) do
        -- Check the arbeiter
        assert(
            arbeiter.name and type(arbeiter.name) ~= "string",
            "Der Name des Moduls muss gesetzt und ein String sein"
        )

        -- Remove the arbeiter by it's name
        registrierteArbeiter[arbeiter.name] = nil
    end
end

---
-- This will init all registrierteArbeiter
-- @param arbeiter a arbeiter of type AkLuaControlModule
function Arbeitsplaner.initialisiereArbeiter()
    for _, arbeiter in pairs(registrierteArbeiter) do
        arbeiter.initialisieren()
    end
end

---
-- This will init all registrierteArbeiter
-- @param arbeiter a arbeiter of type AkLuaControlModule
function Arbeitsplaner.arbeiten()
    for _, arbeiter in pairs(registrierteArbeiter) do
        arbeiter.arbeiten()
    end

    if enableServer then
        AkStatistik.statistikAusgabe()
    end
end

function Arbeitsplaner.aktiviereServerVerbindung()
    enableServer = true
end

return Arbeitsplaner
