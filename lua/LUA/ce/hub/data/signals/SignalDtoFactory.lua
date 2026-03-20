if AkDebugLoad then print("[#Start] Loading ce.hub.data.signals.SignalDtoFactory ...") end

local SignalDtoFactory = {}

local SIGNAL_ROOM = "signals"
local WAITING_ROOM = "waiting-on-signals"
local KEY_ID = "id"

local function toSignalDto(signal)
    return {
        id = signal.id,
        position = signal.position,
        tag = signal.tag,
        waitingVehiclesCount = signal.waitingVehiclesCount
    }
end

function SignalDtoFactory.createSignalDto(signal)
    local dto = toSignalDto(signal)
    return SIGNAL_ROOM, KEY_ID, dto[KEY_ID], dto
end

function SignalDtoFactory.createSignalDtoList(signals)
    local signalDtos = {}

    for i = 1, #signals do
        local _, _, _, dto = SignalDtoFactory.createSignalDto(signals[i])
        signalDtos[i] = dto
    end

    return SIGNAL_ROOM, KEY_ID, signalDtos
end

local function toWaitingOnSignalDto(waiting)
    return {
        id = waiting.id,
        signalId = waiting.signalId,
        waitingPosition = waiting.waitingPosition,
        vehicleName = waiting.vehicleName,
        waitingCount = waiting.waitingCount
    }
end

function SignalDtoFactory.createWaitingOnSignalDto(waiting)
    local dto = toWaitingOnSignalDto(waiting)
    return WAITING_ROOM, KEY_ID, dto[KEY_ID], dto
end

function SignalDtoFactory.createWaitingOnSignalDtoList(waitingOnSignals)
    local waitingOnSignalDtos = {}

    for i = 1, #waitingOnSignals do
        local _, _, _, dto = SignalDtoFactory.createWaitingOnSignalDto(waitingOnSignals[i])
        waitingOnSignalDtos[i] = dto
    end

    return WAITING_ROOM, KEY_ID, waitingOnSignalDtos
end

return SignalDtoFactory
