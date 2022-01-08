if AkDebugLoad then print("[#Start] Loading ak.road.TramSwitch ...") end

local TramSwitch = {}
--- Registriert eine neue Strassenbahnweiche und schaltet das Licht der angegeben Immobilien anhand der Weichenstellung
-- @param switchId ID der Weiche
---@param structure1 string Immobilie, deren Licht bei Weichenstellung 1 leuchten soll
---@param structure2 string Immobilie, deren Licht bei Weichenstellung 2 leuchten soll
---@param structure3 string Immobilie, deren Licht bei Weichenstellung 3 leuchten soll
--
function TramSwitch.new(switchId, structure1, structure2, structure3)
    EEPRegisterSwitch(switchId)
    _G["EEPOnSwitch_" .. switchId] = function(_)
        local currentPosition = EEPGetSwitch(switchId)
        if structure1 then EEPStructureSetLight(structure1, currentPosition == 1) end
        if structure2 then EEPStructureSetLight(structure2, currentPosition == 2) end
        if structure3 then EEPStructureSetLight(structure3, currentPosition == 3) end
    end
    _G["EEPOnSwitch_" .. switchId]()
end

return TramSwitch
