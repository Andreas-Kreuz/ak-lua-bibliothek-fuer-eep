if AkDebugLoad then print("Loading ak.data.SignalJsonCollector ...") end
local SignalJsonCollector = {}
local enabled = true
local initialized = false
SignalJsonCollector.name = "ak.data.SignalJsonCollector"

local MAX_SIGNALS = 1000
local signals = {}

--- Register EEP signals.
-- do it once
function SignalJsonCollector.initialize()
    if not enabled or initialized then return end

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
function SignalJsonCollector.collectData()
    if not enabled then return end

    if not initialized then SignalJsonCollector.initialize() end

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

    return {["signals"] = signals, ["waiting-on-signals"] = waitingOnSignals}
end

return SignalJsonCollector
