insulate("ak.data.SwitchDtoFactory", function ()
    local function clearModule(name) package.loaded[name] = nil end

    before_each(function ()
        clearModule("ak.data.SwitchDtoFactory")
    end)

    it("projects switches to detached DTO tables", function ()
        local SwitchDtoFactory = require("ak.data.SwitchDtoFactory")
        local switch = { id = 11, position = 1, tag = "Main" }

        local switchDto = SwitchDtoFactory.createSwitchDto(switch)
        switch.tag = "Changed"

        assert.same({ id = 11, position = 1, tag = "Main" }, switchDto)
    end)
end)
