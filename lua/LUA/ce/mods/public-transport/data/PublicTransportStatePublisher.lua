if AkDebugLoad then print("[#Start] Loading ce.mods.public-transport.data.PublicTransportStatePublisher ...") end
local LineRegistry = require("ce.mods.public-transport.LineRegistry")
local DataChangeBus = require("ce.hub.publish.DataChangeBus")
local PublicTransportDataCollector = require("ce.mods.public-transport.data.PublicTransportDataCollector")
local PublicTransportDtoFactory = require("ce.mods.public-transport.data.PublicTransportDtoFactory")

---@class PublicTransportStatePublisher
PublicTransportStatePublisher = {}
local enabled = true
local initialized = false
PublicTransportStatePublisher.name = "ce.mods.public-transport.data.PublicTransportStatePublisher"

function PublicTransportStatePublisher.initialize()
    if not enabled or initialized then return end
    initialized = true
end

function PublicTransportStatePublisher.syncState()
    if not enabled then return end
    if not initialized then PublicTransportStatePublisher.initialize() end

    local data = PublicTransportDataCollector.collectPublicTransportData()

    DataChangeBus.fireListChange(
        PublicTransportDtoFactory.createPublicTransportStationDtoList(data.publicTransportStations)
    )
    DataChangeBus.fireListChange(
        PublicTransportDtoFactory.createPublicTransportLineDtoList(data.publicTransportLines)
    )
    DataChangeBus.fireListChange(
        PublicTransportDtoFactory.createPublicTransportModuleSettingDtoList(data.publicTransportSettings)
    )
    LineRegistry.fireChangeLinesEvent()

    return {}
end

return PublicTransportStatePublisher
