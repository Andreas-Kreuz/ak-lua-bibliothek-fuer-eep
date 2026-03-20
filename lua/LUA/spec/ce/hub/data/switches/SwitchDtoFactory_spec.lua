insulate("ce.hub.data.switches.SwitchDtoFactory", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ce.hub.data.switches.SwitchDtoFactory")
    end)

    it("projects switches to detached DTO tables", function ()
        local SwitchDtoFactory = require("ce.hub.data.switches.SwitchDtoFactory")
        local switch = { id = 11, position = 1, tag = "Main" }

        local room, keyId, key, switchDto = SwitchDtoFactory.createSwitchDto(switch)
        local listRoom, listKeyId, switchDtos = SwitchDtoFactory.createSwitchDtoList({ switch })
        switch.tag = "Changed"

        assert.equals("switches", room)
        assert.equals("id", keyId)
        assert.equals(11, key)
        assert.same({ id = 11, position = 1, tag = "Main" }, switchDto)
        assert.equals("switches", listRoom)
        assert.equals("id", listKeyId)
        assert.same({ { id = 11, position = 1, tag = "Main" } }, switchDtos)
    end)
end)
