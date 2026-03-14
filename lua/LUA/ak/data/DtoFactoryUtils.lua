if AkDebugLoad then print("[#Start] Loading ak.data.DtoFactoryUtils ...") end

local DtoFactoryUtils = {}

local function deepCopy(value)
    if type(value) ~= "table" then return value end

    local copy = {}
    for key, entry in pairs(value) do copy[key] = deepCopy(entry) end
    return copy
end

function DtoFactoryUtils.deepCopy(value)
    return deepCopy(value)
end

function DtoFactoryUtils.toDto(value)
    if type(value) == "table" and type(value.toJsonStatic) == "function" then return value:toJsonStatic() end
    return deepCopy(value)
end

return DtoFactoryUtils
