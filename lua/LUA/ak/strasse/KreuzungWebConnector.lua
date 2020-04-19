print("Lade ak.eep.KreuzungWebConnector ...")
local AkStatistik = require("ak.io.AkStatistik")
local KreuzungWebConnector = {}

function KreuzungWebConnector.registerJsonCollectors()
   AkStatistik.addJsonCollector(require("ak.strasse.AmpelModellJsonCollector"))
   AkStatistik.addJsonCollector(require("ak.strasse.KreuzungJsonCollector"))
end

return KreuzungWebConnector
