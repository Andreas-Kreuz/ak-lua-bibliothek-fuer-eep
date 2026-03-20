if AkDebugLoad then print("[#Start] Loading ce.hub.data.version.VersionStatePublisher ...") end
local DataChangeBus = require("ce.hub.publish.DataChangeBus")
local VersionDataCollector = require("ce.hub.data.version.VersionDataCollector")
local VersionDtoFactory = require("ce.hub.data.version.VersionDtoFactory")
VersionStatePublisher = {}
local enabled = true
local data = {}
local initialized = false
VersionStatePublisher.name = "ce.hub.VersionStatePublisher"

function VersionStatePublisher.initialize()
    if not enabled or initialized then return end

    local versionInfo = VersionDataCollector.collectVersionInfo()
    -- TODO: Send event only with detected changes
    DataChangeBus.fireListChange(
        VersionDtoFactory.createVersionDtoList(
            versionInfo.eepVersion,
            versionInfo.luaVersion,
            versionInfo.singleVersion))
    data = {
        -- ["eep-version"] = versionDtos
    }
    initialized = true
end

function VersionStatePublisher.syncState() return data end

return VersionStatePublisher
