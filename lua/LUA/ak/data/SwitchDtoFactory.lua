if AkDebugLoad then print("[#Start] Loading ak.data.SwitchDtoFactory ...") end

local SwitchDtoFactory = {}

function SwitchDtoFactory.createSwitchDto(switch)
    return {
        id = switch.id,
        position = switch.position,
        tag = switch.tag
    }
end

function SwitchDtoFactory.createSwitchDtoList(switches)
    local switchDtos = {}

    for i = 1, #switches do
        switchDtos[i] = SwitchDtoFactory.createSwitchDto(switches[i])
    end

    return switchDtos
end

return SwitchDtoFactory
