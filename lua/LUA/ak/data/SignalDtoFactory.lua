if AkDebugLoad then print("[#Start] Loading ak.data.SignalDtoFactory ...") end

local SignalDtoFactory = {}

function SignalDtoFactory.createSignalDto(signal)
    return {
        id = signal.id,
        position = signal.position,
        tag = signal.tag,
        waitingVehiclesCount = signal.waitingVehiclesCount
    }
end

function SignalDtoFactory.createSignalDtoList(signals)
    local signalDtos = {}

    for i = 1, #signals do
        signalDtos[i] = SignalDtoFactory.createSignalDto(signals[i])
    end

    return signalDtos
end

function SignalDtoFactory.createWaitingOnSignalDto(waiting)
    return {
        id = waiting.id,
        signalId = waiting.signalId,
        waitingPosition = waiting.waitingPosition,
        vehicleName = waiting.vehicleName,
        waitingCount = waiting.waitingCount
    }
end

function SignalDtoFactory.createWaitingOnSignalDtoList(waitingOnSignals)
    local waitingOnSignalDtos = {}

    for i = 1, #waitingOnSignals do
        waitingOnSignalDtos[i] = SignalDtoFactory.createWaitingOnSignalDto(waitingOnSignals[i])
    end

    return waitingOnSignalDtos
end

return SignalDtoFactory
