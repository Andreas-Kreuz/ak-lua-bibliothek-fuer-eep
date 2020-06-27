if AkDebugLoad then print("Loading ak.train.ModelV15NMA10013 ...") end
local RollingStockModel = require("ak.train.RollingStockModel")

local ModelV15NMA10013 = {}

GT_A = RollingStockModel:new({})

function GT_A:setLine(rollingStockName, line)
    assert(self)
    EEPRollingstockSetTextureText(rollingStockName, 1, line)
    EEPRollingstockSetTextureText(rollingStockName, 4, line .. " - 01")
end

function GT_A:setDestination(rollingStockName, destination)
    assert(self)
    EEPRollingstockSetTextureText(rollingStockName, 2, destination)
end

function GT_A:setStations(rollingStockName, stations)
    assert(self)
    EEPRollingstockSetTextureText(rollingStockName, 3, stations)
end

function GT_A:setWagonNr(rollingStockName, nr)
    assert(self)
    EEPRollingstockSetTextureText(rollingStockName, 5, nr)
    EEPRollingstockSetTextureText(rollingStockName, 6, nr)
    EEPRollingstockSetTextureText(rollingStockName, 7, nr)
    EEPRollingstockSetTextureText(rollingStockName, 8, nr)
end

function GT_A:openDoors(rollingStockName)
    assert(self)
    EEPRollingstockSetAxis(rollingStockName, "Türen Mitte", 100)
    EEPRollingstockSetAxis(rollingStockName, "Türen vorn", 100)
end

function GT_A:openDoors(rollingStockName)
    assert(self)
    EEPRollingstockSetAxis(rollingStockName, "Türen Mitte", 0)
    EEPRollingstockSetAxis(rollingStockName, "Türen vorn", 0)
end

ModelV15NMA10013["GT4 Serie 2 (1) Wagen A"] = GT_A
ModelV15NMA10013["GT4 Serie 2 (2) Wagen A"] = GT_A

local GT_B = RollingStockModel:new({})

function GT_B:setLine(rollingStockName, line)
    assert(self)
    EEPRollingstockSetTextureText(rollingStockName, 1, line)
end

function GT_B:setDestination(rollingStockName, destination)
    assert(self)
    assert(rollingStockName)
    assert(destination)
 end

function GT_B:setStations(rollingStockName, stations)
    assert(self)
    EEPRollingstockSetTextureText(rollingStockName, 2, stations)
end

function GT_B:setWagonNr(rollingStockName, nr)
    assert(self)
    EEPRollingstockSetTextureText(rollingStockName, 3, nr)
    EEPRollingstockSetTextureText(rollingStockName, 4, nr)
end

function GT_B:openDoors(rollingStockName)
    assert(self)
    EEPRollingstockSetAxis(rollingStockName, "Türen hinten", 100)
end

function GT_B:closeDoors(rollingStockName)
    assert(self)
    EEPRollingstockSetAxis(rollingStockName, "Türen hinten", 0)
end

ModelV15NMA10013["GT4 Serie 2 (1) Wagen B"] = GT_B
ModelV15NMA10013["GT4 Serie 2 (2) Wagen B"] = GT_B

return ModelV15NMA10013
