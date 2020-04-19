print"Lade ak.data.VersionPublisher ..."
VersionPublisher = {}
local AkStatistik = require("ak.io.AkStatistik")
local enabled = true
local initialized = false
VersionPublisher.name = "ak.data.VersionPublisher"

function VersionPublisher.initialize()
    if not enabled or initialized then
        return
    end

    local versions = {
        versionInfo = {
            -- EEP-Web expects a named entry here
            name = "versionInfo", -- EEP-Web requires that data entries have an id or name tag
            eepVersion = string.format("%.1f", EEPVer), -- show string instead of float
            luaVersion = _VERSION,
            singleVersion = {AkStatistik = AkStatistik.programVersion} -- EEP-Web does not show this object value
        }
    }

    AkStatistik.writeLater("eep-version", versions)
    initialized = true
end

function VersionPublisher.updateData() end

return VersionPublisher