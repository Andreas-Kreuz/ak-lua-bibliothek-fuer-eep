if AkDebugLoad then print("[#Start] Loading ak.core.VersionStatePublisher ...") end
local DataChangeBus = require("ak.events.DataChangeBus")
VersionStatePublisher = {}
local ServerController = require("ak.io.ServerController")
local enabled = true
local data = {}
local initialized = false
VersionStatePublisher.name = "ak.core.VersionStatePublisher"

function VersionStatePublisher.initialize()
    if not enabled or initialized then return end

    local versions = {
        versionInfo = {
            -- EEP-Web expects a named entry here
            id = "versionInfo",                         -- EEP-Web requires that data entries have an id or name tag
            name = "versionInfo",                       -- EEP-Web requires that data entries have an id or name tag
            eepVersion = string.format("%.1f", EEPVer), -- show string instead of float
            luaVersion = _VERSION,
            singleVersion = ServerController.programVersion
        }
    }

    -- TODO: Send event only with detected changes
    DataChangeBus.fireListChange("eep-version", "id", versions)
    data = {
        -- ["eep-version"] = versions
    }
    initialized = true
end

function VersionStatePublisher.collectData() return data end

return VersionStatePublisher
