if AkDebugLoad then print("[#Start] Loading ce.hub.data.signals.SignalStatePublisher ...") end
local DataChangeBus = require("ce.hub.publish.DataChangeBus")
local SignalDataCollector = require("ce.hub.data.signals.SignalDataCollector")
local SignalDtoFactory = require("ce.hub.data.signals.SignalDtoFactory")
local SignalStatePublisher = {}
local enabled = true
local initialized = false
SignalStatePublisher.name = "ce.hub.data.signals.SignalStatePublisher"

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

    DataChangeBus.fireListChange(SignalDtoFactory.createSignalDtoList(signals))
    DataChangeBus.fireListChange(SignalDtoFactory.createWaitingOnSignalDtoList(waitingOnSignals))

    return {}
end

return SignalStatePublisher
