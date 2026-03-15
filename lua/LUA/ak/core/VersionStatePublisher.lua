if AkDebugLoad then print("[#Start] Loading ak.core.VersionStatePublisher ...") end
local DataChangeBus = require("ak.events.DataChangeBus")
local VersionInfo = require("ak.core.VersionInfo")
local VersionDtoFactory = require("ak.core.VersionDtoFactory")
VersionStatePublisher = {}
local enabled = true
local data = {}
local initialized = false
VersionStatePublisher.name = "ak.core.VersionStatePublisher"

function VersionStatePublisher.initialize()
    if not enabled or initialized then return end

    -- TODO: Send event only with detected changes
    DataChangeBus.fireListChange(
        VersionDtoFactory.createVersionDtoList(
            string.format("%.1f", EEPVer),
            _VERSION,
            VersionInfo.getProgramVersion()))
    data = {
        -- ["eep-version"] = versionDtos
    }
    initialized = true
end

function VersionStatePublisher.syncState() return data end

return VersionStatePublisher
