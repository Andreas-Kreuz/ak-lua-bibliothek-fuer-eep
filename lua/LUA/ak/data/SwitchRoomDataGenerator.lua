if AkDebugLoad then print("[#Start] Loading ak.data.SwitchRoomDataGenerator ...") end

local SwitchRoomDataGenerator = {}

function SwitchRoomDataGenerator.toRoomDataSwitch(switch)
    return {
        id = switch.id,
        position = switch.position,
        tag = switch.tag
    }
end

function SwitchRoomDataGenerator.toRoomDataSwitchList(switches)
    local roomDataSwitches = {}

    for i = 1, #switches do
        roomDataSwitches[i] = SwitchRoomDataGenerator.toRoomDataSwitch(switches[i])
    end

    return roomDataSwitches
end

return SwitchRoomDataGenerator
