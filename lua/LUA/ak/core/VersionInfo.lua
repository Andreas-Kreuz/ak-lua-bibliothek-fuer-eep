if AkDebugLoad then print("[#Start] Loading ak.core.VersionInfo ...") end

local VersionInfo = {}
local programVersion = nil

local function readProgramVersion()
    local file = io.open("LUA/ak/VERSION", "r")
    if file then
        local version = file:read()
        file:close()
        return version
    end

    return "NO VERSION IN LUA/ak/VERSION"
end

function VersionInfo.getProgramVersion()
    if programVersion == nil then programVersion = readProgramVersion() end
    return programVersion
end

return VersionInfo