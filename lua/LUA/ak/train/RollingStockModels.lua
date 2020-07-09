if AkDebugLoad then print("Loading ak.train.RollingStockModels ...") end

local RollingStockModels = {}
local assignedModels = {}
local nameModels = {}

---Assigns a certain model for the given model name ( Name in EEP before the ";")
---@param modelName string name of the rollingstock as in EEP before the ";"
---@param model RollingStockModel name of the rollingstock as in EEP before the ";"
function RollingStockModels.addModelByName(modelName, model) nameModels[modelName] = model end

---Assigns a certain model for the given rollingstock name (complete Name in EEP)
---@param rollingStockName string name of the rollingstock including the ";" if used in EEP
function RollingStockModels.assignModel(rollingStockName, model) assignedModels[rollingStockName] = model end

---Returns the model for the given rollingstock by looking in assignedModels first and then in namedModels
---@param rollingStockName string name of the rollingstock
---@return RollingStockModel
function RollingStockModels.modelFor(rollingStockName)
    if assignedModels[rollingStockName] then
        return assignedModels[rollingStockName]
    else
        local modelName = RollingStockModels.parseModelName(rollingStockName)
        return findModelByName(modelName)
    end
end

---Parse the name of the model by cutting all characters after the first ";"
---@param rollingStockName string name of the rollingstock
function RollingStockModels.parseModelName(rollingStockName) return rollingStockName:match("[^;]*") end

---Lookup in the registered models
---@param modelName string name of the model
---@see RollingStockModels.parseModelName
function findModelByName(modelName)
    if nameModels[modelName] then
        return nameModels[modelName]
    else
        local RollingStockModel = require("ak.train.RollingStockModel")
        return RollingStockModel:new({})
    end
end

-- ADD STATIC MODELS
local ModelV15NMA10013 = require("ak.train.ModelV15NMA10013")
RollingStockModels.addModelByName("GT4 Serie 2 (1) Wagen A", ModelV15NMA10013["GT4 Serie 2 (1) Wagen A"])
RollingStockModels.addModelByName("GT4 Serie 2 (1) Wagen B", ModelV15NMA10013["GT4 Serie 2 (1) Wagen B"])
RollingStockModels.addModelByName("GT4 Serie 2 (2) Wagen A", ModelV15NMA10013["GT4 Serie 2 (2) Wagen A"])
RollingStockModels.addModelByName("GT4 Serie 2 (2) Wagen B", ModelV15NMA10013["GT4 Serie 2 (2) Wagen B"])

return RollingStockModels
