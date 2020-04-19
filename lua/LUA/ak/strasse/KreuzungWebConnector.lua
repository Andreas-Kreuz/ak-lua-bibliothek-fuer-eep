print("Lade ak.eep.KreuzungWebConnector ...")
local AkStatistik = require("ak.io.AkStatistik")
local KreuzungWebConnector = {}

function KreuzungWebConnector.registerJsonControllers()
    AkStatistik.addJsonCollector(require("ak.data.DataSlotsJsonCollector"))
    AkStatistik.addJsonCollector(require("ak.data.SignalJsonCollector"))
    AkStatistik.addJsonCollector(require("ak.data.SwitchJsonCollector"))
    AkStatistik.addJsonCollector(require("ak.data.StructureJsonCollector"))
    AkStatistik.addJsonCollector(require("ak.data.TimeJsonCollector"))
    AkStatistik.addJsonCollector(require("ak.data.TrainsAndTracksJsonCollector"))
    AkStatistik.addJsonCollector(require("ak.data.VersionJsonCollector"))
end

return KreuzungWebConnector
