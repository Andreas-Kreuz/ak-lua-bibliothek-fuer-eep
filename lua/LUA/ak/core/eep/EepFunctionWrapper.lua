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

return EepFunctionWrapper
