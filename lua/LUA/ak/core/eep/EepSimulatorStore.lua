if AkDebugLoad then print("[#Start] Loading ak.core.eep.EepSimulatorStore ...") end

local Store = {}

Store.state = {
    tracks = {
        rail = {},
        road = {},
        tram = {},
        auxiliary = {},
        control = {}
    },
    trains = {},
    trainyards = {},
    structures = {},
    signals = {},
    switches = {},
    goods = {},
    camera = {
        perspectiveByTrain = {},
        userRollingstock = {}
    },
    signalQueues = {
        countBySignal = {},
        namesBySignal = {}
    },
    active = {
        trainName = "",
        rollingstockName = nil
    },
    rollingstock = {
        hookByName = {},
        hookGlueByName = {}
    },
    persistence = {
        dataSlots = {}
    },
    structureRuntime = {
        axisByStructure = {}
    },
    weather = {
        wind = nil,
        rain = nil,
        snow = nil,
        hail = nil,
        fog = nil,
        clouds = nil
    }
}

local function createValue(defaultFactory)
    if type(defaultFactory) == "function" then return defaultFactory() end
    if defaultFactory ~= nil then return defaultFactory end
    return {}
end

function Store.getPath(root, path)
    local current = root
    for _, key in ipairs(path) do
        if type(current) ~= "table" then return nil end
        current = current[key]
        if current == nil then return nil end
    end
    return current
end

function Store.ensurePath(root, path, defaultFactory)
    local current = root
    for index = 1, #path - 1 do
        local key = path[index]
        if current[key] == nil then current[key] = {} end
        current = current[key]
    end

    local leafKey = path[#path]
    if current[leafKey] == nil then current[leafKey] = createValue(defaultFactory) end
    return current[leafKey]
end

return Store
