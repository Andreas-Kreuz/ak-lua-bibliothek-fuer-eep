if AkDebugLoad then print("[#Start] Loading ak.data.DataWebConnector ...") end
local ServerController = require("ak.io.ServerController")
local DataWebConnector = {}

function DataWebConnector.registerJsonCollectors(activeCollectors)
    local all = true
    if activeCollectors then
        if next(activeCollectors) ~= nil then -- not empty list
            all = false
        end
    end

    if all or activeCollectors["ak.data.DataSlotsJsonCollector"] then
        local dataSlotsJsonCollector = require("ak.data.DataSlotsJsonCollector")
        ServerController.addJsonCollector(dataSlotsJsonCollector)
    end
    if all or activeCollectors["ak.data.SignalJsonCollector"] then
        local signalJsonCollector = require("ak.data.SignalJsonCollector")
        ServerController.addJsonCollector(signalJsonCollector)
    end
    if all or activeCollectors["ak.data.SwitchJsonCollector"] then
        local switchJsonCollector = require("ak.data.SwitchJsonCollector")
        ServerController.addJsonCollector(switchJsonCollector)
    end
    if all or activeCollectors["ak.data.StructureJsonCollector"] then
        local structureJsonCollector = require("ak.data.StructureJsonCollector")
        ServerController.addJsonCollector(structureJsonCollector)
    end
    if all or activeCollectors["ak.data.TimeJsonCollector"] then
        local timeJsonCollector = require("ak.data.TimeJsonCollector")
        ServerController.addJsonCollector(timeJsonCollector)
    end
    if all or activeCollectors["ak.data.TrainsAndTracksJsonCollector"] then
        local trainsAndTracksJsonCollector = require("ak.data.TrainsAndTracksJsonCollector")
        ServerController.addJsonCollector(trainsAndTracksJsonCollector)
    end
end

return DataWebConnector
