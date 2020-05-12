print("Loading ak.data.DataWebConnector ...")
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
        ServerController.addJsonCollector(require("ak.data.DataSlotsJsonCollector"))
    end
    if all or activeCollectors["ak.data.SignalJsonCollector"] then
        ServerController.addJsonCollector(require("ak.data.SignalJsonCollector"))
    end
    if all or activeCollectors["ak.data.SwitchJsonCollector"] then
        ServerController.addJsonCollector(require("ak.data.SwitchJsonCollector"))
    end
    if all or activeCollectors["ak.data.StructureJsonCollector"] then
        ServerController.addJsonCollector(require("ak.data.StructureJsonCollector"))
    end
    if all or activeCollectors["ak.data.TimeJsonCollector"] then
        ServerController.addJsonCollector(require("ak.data.TimeJsonCollector"))
    end
    if all or activeCollectors["ak.data.TrainsAndTracksJsonCollector"] then
        ServerController.addJsonCollector(require("ak.data.TrainsAndTracksJsonCollector"))
    end
end

return DataWebConnector
