print("Lade ak.eep.KreuzungWebConnector ...")
local ServerController = require("ak.io.ServerController")
local KreuzungWebConnector = {}

function KreuzungWebConnector.registerJsonCollectors()
   ServerController.addJsonCollector(require("ak.strasse.AmpelModellJsonCollector"))
   ServerController.addJsonCollector(require("ak.strasse.KreuzungJsonCollector"))
end

return KreuzungWebConnector
