if AkDebugLoad then print("Loading ak.core.VersionJsonCollector ...") end
VersionJsonCollector = {}
local ServerController = require("ak.io.ServerController")
local enabled = true
local data = {}
local initialized = false
VersionJsonCollector.name = "ak.core.VersionJsonCollector"

function VersionJsonCollector.initialize()
    if not enabled or initialized then
        return
    end

    local versions = {
        versionInfo = {
            -- EEP-Web expects a named entry here
            name = "versionInfo", -- EEP-Web requires that data entries have an id or name tag
            eepVersion = string.format("%.1f", EEPVer), -- show string instead of float
            luaVersion = _VERSION,
            singleVersion = ServerController.programVersion,
        }
    }

    data = {["eep-version"] = versions}
    initialized = true
end

function VersionJsonCollector.collectData()
    return data
end

return VersionJsonCollector
