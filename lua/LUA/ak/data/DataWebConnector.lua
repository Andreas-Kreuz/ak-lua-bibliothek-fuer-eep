if AkDebugLoad then print("[#Start] Loading ak.data.DataWebConnector ...") end
local ServerController = require("ak.io.ServerController")
local DataWebConnector = {}

function DataWebConnector.registerStatePublishers(activeCollectors)
    local all = true
    if activeCollectors then
        if next(activeCollectors) ~= nil then -- not empty list
            all = false
        end
    end

    if all or activeCollectors["ak.data.DataSlotsStatePublisher"] then
        local dataSlotsStatePublisher = require("ak.data.DataSlotsStatePublisher")
        ServerController.addStatePublisher(dataSlotsStatePublisher)
    end
    if all or activeCollectors["ak.data.SignalStatePublisher"] then
        local signalStatePublisher = require("ak.data.SignalStatePublisher")
        ServerController.addStatePublisher(signalStatePublisher)
    end
    if all or activeCollectors["ak.data.SwitchStatePublisher"] then
        local switchStatePublisher = require("ak.data.SwitchStatePublisher")
        ServerController.addStatePublisher(switchStatePublisher)
    end
    if all or activeCollectors["ak.data.StructureStatePublisher"] then
        local structureStatePublisher = require("ak.data.StructureStatePublisher")
        ServerController.addStatePublisher(structureStatePublisher)
    end
    if all or activeCollectors["ak.data.TimeStatePublisher"] then
        local timeStatePublisher = require("ak.data.TimeStatePublisher")
        ServerController.addStatePublisher(timeStatePublisher)
    end
    if all or activeCollectors["ak.data.TrainsAndTracksStatePublisher"] then
        local trainsAndTracksStatePublisher = require("ak.data.TrainsAndTracksStatePublisher")
        ServerController.addStatePublisher(trainsAndTracksStatePublisher)
    end
end

return DataWebConnector
