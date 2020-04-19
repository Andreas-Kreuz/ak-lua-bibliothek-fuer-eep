print"Lade ak.data.SignalPublisher ..."
local SignalPublisher = {}
local AkStatistik = require("ak.io.AkStatistik")
local enabled = true
local initialized = false
SignalPublisher.name = "ak.data.SignalPublisher"

local MAX_SIGNALS = 1000
local signals = {}

--- Register EEP signals.
-- do it once
function SignalPublisher.initialize()
    if not enabled or initialized then
        return
    end

    signals = {}
    for i = 1, MAX_SIGNALS do
        local val = EEPGetSignal(i)
        if val > 0 then -- yes, this is a signal
            local signal = {}
            signal.id = i
            table.insert(signals, signal)
        end
    end

    initialized = true
end

--- Get EEP signals and store them.
-- do it frequently
function SignalPublisher.updateData()
    if not enabled then
        AkStatistik.writeLater("signals", nil)
        AkStatistik.writeLater("waiting-on-signals", nil)
        return
    end

    if not initialized then
        SignalPublisher.initialize()
    end

    local waitingOnSignals = {}
    for i = 1, #signals do
        local signal = signals[i]
        signal.position = EEPGetSignal(signal.id)
        local waitingVehiclesCount = EEPGetSignalTrainsCount(signal.id) -- EEP 13.2
        signal.waitingVehiclesCount = waitingVehiclesCount or 0

        if waitingVehiclesCount then
            for position = 1, waitingVehiclesCount do
                local vehicleName = EEPGetSignalTrainName(signal.id, position) -- EEP 13.2
                local waiting = {
                    id = signal.id .. "-" .. position,
                    signalId = signal.id,
                    waitingPosition = position,
                    vehicleName = vehicleName or "",
                    waitingCount = waitingVehiclesCount
                }
                table.insert(waitingOnSignals, waiting)
            end
        end
    end

    AkStatistik.writeLater("signals", signals)
    AkStatistik.writeLater("waiting-on-signals", waitingOnSignals)
end

return SignalPublisher
