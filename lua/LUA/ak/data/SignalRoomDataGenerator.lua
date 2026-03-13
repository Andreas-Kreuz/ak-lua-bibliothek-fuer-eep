if AkDebugLoad then print("[#Start] Loading ak.data.SignalRoomDataGenerator ...") end

local SignalRoomDataGenerator = {}

function SignalRoomDataGenerator.toRoomDataSignal(signal)
    return {
        id = signal.id,
        position = signal.position,
        tag = signal.tag,
        waitingVehiclesCount = signal.waitingVehiclesCount
    }
end

function SignalRoomDataGenerator.toRoomDataSignalList(signals)
    local roomDataSignals = {}

    for i = 1, #signals do
        roomDataSignals[i] = SignalRoomDataGenerator.toRoomDataSignal(signals[i])
    end

    return roomDataSignals
end

function SignalRoomDataGenerator.toRoomDataWaitingOnSignal(waiting)
    return {
        id = waiting.id,
        signalId = waiting.signalId,
        waitingPosition = waiting.waitingPosition,
        vehicleName = waiting.vehicleName,
        waitingCount = waiting.waitingCount
    }
end

function SignalRoomDataGenerator.toRoomDataWaitingOnSignalList(waitingOnSignals)
    local roomDataWaitingOnSignals = {}

    for i = 1, #waitingOnSignals do
        roomDataWaitingOnSignals[i] = SignalRoomDataGenerator.toRoomDataWaitingOnSignal(waitingOnSignals[i])
    end

    return roomDataWaitingOnSignals
end

return SignalRoomDataGenerator
