if AkDebugLoad then print("[#Start] Loading ce.hub.data.switches.SwitchDtoFactory ...") end

local SwitchDtoFactory = {}

local ROOM = "switches"
local KEY_ID = "id"

local function toSwitchDto(switch)
    return {
        id = switch.id,
        position = switch.position,
        tag = switch.tag
    }
end

function SwitchDtoFactory.createSwitchDto(switch)
    local dto = toSwitchDto(switch)
    return ROOM, KEY_ID, dto[KEY_ID], dto
end

function SwitchDtoFactory.createSwitchDtoList(switches)
    local switchDtos = {}

    for i = 1, #switches do
        local _, _, _, dto = SwitchDtoFactory.createSwitchDto(switches[i])
        switchDtos[i] = dto
    end

    return ROOM, KEY_ID, switchDtos
end

return SwitchDtoFactory
