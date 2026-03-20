if AkDebugLoad then print("[#Start] Loading ce.hub.data.signals.SignalDataCollector ...") end

local SignalDataCollector = {}

local MAX_SIGNALS = 1000

local EEPGetSignal = _G.EEPGetSignal or function () end
local EEPSignalGetTagText = _G.EEPSignalGetTagText or function () end
local EEPGetSignalTrainsCount = _G.EEPGetSignalTrainsCount or function () end
local EEPGetSignalTrainName = _G.EEPGetSignalTrainName or function () end

function SignalDataCollector.collectInitialSignals()
    local signals = {}

    for i = 1, MAX_SIGNALS do
        local val = EEPGetSignal(i)
        if val > 0 then
            table.insert(signals, { id = i })
        end
    end

    return signals
end

function SignalDataCollector.refreshSignals(signals)
    for i = 1, #signals do
        local signal = signals[i]
        signal.position = EEPGetSignal(signal.id)
        local _, tag = EEPSignalGetTagText(signal.id)
        signal.tag = tag or ""
        local waitingVehiclesCount = EEPGetSignalTrainsCount(signal.id)
        signal.waitingVehiclesCount = waitingVehiclesCount or 0
    end
end

function SignalDataCollector.collectWaitingOnSignals(signals)
    local waitingOnSignals = {}

    for i = 1, #signals do
        local signal = signals[i]
        local waitingVehiclesCount = signal.waitingVehiclesCount

        if waitingVehiclesCount then
            for position = 1, waitingVehiclesCount do
                local vehicleName = EEPGetSignalTrainName(signal.id, position)
                table.insert(waitingOnSignals, {
                    id = signal.id .. "-" .. position,
                    signalId = signal.id,
                    waitingPosition = position,
                    vehicleName = vehicleName or "",
                    waitingCount = waitingVehiclesCount
                })
            end
        end
    end

    return waitingOnSignals
end

return SignalDataCollector
