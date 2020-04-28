print("Load ak.data.DataWebConnector ...")
local ServerController = require("ak.io.ServerController")
local DataWebConnector = {}

function DataWebConnector.registerJsonCollectors()
    ServerController.addJsonCollector(require("ak.data.DataSlotsJsonCollector"))
    ServerController.addJsonCollector(require("ak.data.SignalJsonCollector"))
    ServerController.addJsonCollector(require("ak.data.SwitchJsonCollector"))
    ServerController.addJsonCollector(require("ak.data.StructureJsonCollector"))
    ServerController.addJsonCollector(require("ak.data.TimeJsonCollector"))
    ServerController.addJsonCollector(require("ak.data.TrainsAndTracksJsonCollector"))
end

return DataWebConnector
