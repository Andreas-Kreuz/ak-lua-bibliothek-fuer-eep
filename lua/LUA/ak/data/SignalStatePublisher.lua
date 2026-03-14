if AkDebugLoad then print("[#Start] Loading ak.data.SignalStatePublisher ...") end
local DataChangeBus = require("ak.events.DataChangeBus")
local SignalDataCollector = require("ak.data.SignalDataCollector")
local SignalDtoFactory = require("ak.data.SignalDtoFactory")
local SignalStatePublisher = {}
local enabled = true
local initialized = false
SignalStatePublisher.name = "ak.data.SignalStatePublisher"

local signals = {}

function SignalStatePublisher.initialize()
    if not enabled or initialized then return end

    signals = SignalDataCollector.collectInitialSignals()

    initialized = true
end

function SignalStatePublisher.syncState()
    if not enabled then return end

    if not initialized then SignalStatePublisher.initialize() end

    SignalDataCollector.refreshSignals(signals)
    local waitingOnSignals = SignalDataCollector.collectWaitingOnSignals(signals)
    local signalDtos = SignalDtoFactory.createSignalDtoList(signals)
    local waitingDtos = SignalDtoFactory.createWaitingOnSignalDtoList(waitingOnSignals)

    DataChangeBus.fireListChange("signals", "id", signalDtos)
    DataChangeBus.fireListChange("waiting-on-signals", "id", waitingDtos)

    return {}
end

return SignalStatePublisher
