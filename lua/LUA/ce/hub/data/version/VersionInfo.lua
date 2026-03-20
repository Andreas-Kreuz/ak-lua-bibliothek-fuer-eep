if AkDebugLoad then print("[#Start] Loading ce.hub.data.version.VersionInfo ...") end

-- TODO What is this used for? Do we need it? Can we remove it?
local VersionInfo = {}
local programVersion = nil

local function readProgramVersion()
    local file = io.open("LUA/ce/VERSION", "r")
    if file then
        local version = file:read()
        file:close()
        return version
    end

    return "NO VERSION IN LUA/ce/VERSION"
end

function VersionInfo.getProgramVersion()
    if programVersion == nil then programVersion = readProgramVersion() end
    return programVersion
end

return VersionInfo
