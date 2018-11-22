print("Lade ak.strasse.AkStrabWeiche ...")

local AkStrabWeiche = {}
--- Registriert eine neue Strassenbahnweiche und schaltet das Licht der angegeben Immobilien anhand der Weichenstellung
-- @param weiche_id ID der Weiche
-- @param immo1 Immobilie, deren Licht bei Weichenstellung 1 leuchten soll
-- @param immo2 Immobilie, deren Licht bei Weichenstellung 2 leuchten soll
-- @param immo3 Immobilie, deren Licht bei Weichenstellung 3 leuchten soll
--
function AkStrabWeiche.new(weiche_id, immo1, immo2, immo3)
    EEPRegisterSwitch(weiche_id)
    _G["EEPOnSwitch_" .. weiche_id] = function(_)
        local stellung = EEPGetSwitch(weiche_id)
        if immo1 then EEPStructureSetLight(immo1, stellung == 1) end
        if immo2 then EEPStructureSetLight(immo2, stellung == 2) end
        if immo3 then EEPStructureSetLight(immo3, stellung == 3) end
    end
    _G["EEPOnSwitch_" .. weiche_id]()
end

return AkStrabWeiche