local EepFunctionWrapper = {}

EepFunctionWrapper.EEPGetTrainLength = EEPGetTrainLength or function(trainName)
    local rollingStockCount = EEPGetRollingstockItemsCount(trainName) -- EEP 13.2 Plug-In 2

    local length = 0
    for i = 0, (rollingStockCount - 1) do
        local rollingStockName = EEPGetRollingstockItemName(trainName, i) -- EEP 13.2 Plug-In 2
        local _, rslength = EEPRollingstockGetLength(rollingStockName) -- EEP 15
        length = length + rslength
    end
    return length
end

--- Ermittelt die zurückgelegte Strecke des Rollmaterials in Meter (m)
--  OK, Mileage = EEPRollingstockGetMileage("#Fahrzeug")
EEPRollingstockGetMileage = EEPRollingstockGetMileage or function() end -- EEP 16.1

--- Ermittelt die Position des Rollmaterials im EEP-Koordinatensystem in Meter (m).
--  OK, PosX, PosY, PosZ = EEPRollingstockGetPosition("#Fahrzeug")
EEPRollingstockGetPosition = EEPRollingstockGetPosition or function() end -- EEP 16.1

EEPRollingstockGetLength = EEPRollingstockGetLength or function() end -- EEP 14.2

EEPRollingstockGetMotor = EEPRollingstockGetMotor or function() end -- EEP 14.2

EEPRollingstockGetTrack = EEPRollingstockGetTrack or function() end -- EEP 14.2

EEPRollingstockGetModelType = EEPRollingstockGetModelType or function() end -- EEP 14.2

EEPRollingstockGetTagText = EEPRollingstockGetTagText or function() end -- EEP 14.2

-- Liest den Text einer beschreibbaren Fläche eines Rollmaterials aus
EEPRollingstockGetTextureText = EEPRollingstockGetTextureText or function() end -- EEP16.3

return EepFunctionWrapper
