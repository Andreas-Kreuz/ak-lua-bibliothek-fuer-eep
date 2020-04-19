print("Lade ak.eep.CoreWebConnector ...")
local ServerController = require("ak.io.ServerController")
local CoreWebConnector = {}

function CoreWebConnector.registerJsonCollectors()
    ServerController.addJsonCollector(require("ak.data.DataSlotsJsonCollector"))
    ServerController.addJsonCollector(require("ak.data.SignalJsonCollector"))
    ServerController.addJsonCollector(require("ak.data.SwitchJsonCollector"))
    ServerController.addJsonCollector(require("ak.data.StructureJsonCollector"))
    ServerController.addJsonCollector(require("ak.data.TimeJsonCollector"))
    ServerController.addJsonCollector(require("ak.data.TrainsAndTracksJsonCollector"))
    ServerController.addJsonCollector(require("ak.data.VersionJsonCollector"))
end

return CoreWebConnector
