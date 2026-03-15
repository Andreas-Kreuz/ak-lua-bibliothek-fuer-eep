insulate("VersionInfo", function ()
    local function clearModule(name)
        package.loaded[name] = nil
    end

    local originalIoOpen = io.open

    before_each(function ()
        clearModule("ak.core.VersionInfo")
        io.open = originalIoOpen
    end)

    after_each(function ()
        io.open = originalIoOpen
    end)

    it("reads the program version lazily and caches it", function ()
        local openCalls = 0
        io.open = function (fileName, mode)
            if fileName ~= "LUA/ak/VERSION" then return originalIoOpen(fileName, mode) end

            openCalls = openCalls + 1
            assert.equals("LUA/ak/VERSION", fileName)
            assert.equals("r", mode)

            return {
                read = function () return "9.9.9" end,
                close = function () end
            }
        end

        local VersionInfo = require("ak.core.VersionInfo")

        assert.equals("9.9.9", VersionInfo.getProgramVersion())
        assert.equals("9.9.9", VersionInfo.getProgramVersion())
        assert.equals(1, openCalls)
    end)

    it("returns a fallback text if the version file is missing", function ()
        io.open = function () return nil end

        local VersionInfo = require("ak.core.VersionInfo")

        assert.equals("NO VERSION IN LUA/ak/VERSION", VersionInfo.getProgramVersion())
    end)
end)
