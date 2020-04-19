print("Lade ak.eep.CoreWebConnector ...")
local AkStatistik = require("ak.io.AkStatistik")
local CoreWebConnector = {}

function CoreWebConnector.registerJsonCollectors()
    AkStatistik.addJsonCollector(require("ak.data.DataSlotsJsonCollector"))
    AkStatistik.addJsonCollector(require("ak.data.SignalJsonCollector"))
    AkStatistik.addJsonCollector(require("ak.data.SwitchJsonCollector"))
    AkStatistik.addJsonCollector(require("ak.data.StructureJsonCollector"))
    AkStatistik.addJsonCollector(require("ak.data.TimeJsonCollector"))
    AkStatistik.addJsonCollector(require("ak.data.TrainsAndTracksJsonCollector"))
    AkStatistik.addJsonCollector(require("ak.data.VersionJsonCollector"))
end

return CoreWebConnector
