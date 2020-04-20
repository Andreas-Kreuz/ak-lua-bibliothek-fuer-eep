print("Lade ak.eep.KreuzungWebConnector ...")
local ServerController = require("ak.io.ServerController")
local AkKreuzung = require("ak.strasse.AkKreuzung")
local KreuzungWebConnector = {}

function KreuzungWebConnector.registerJsonCollectors()
    ServerController.addJsonCollector(require("ak.strasse.AmpelModellJsonCollector"))
    ServerController.addJsonCollector(require("ak.strasse.KreuzungJsonCollector"))
end

function KreuzungWebConnector.registerFunctions()
    ServerController.addAcceptedRemoteFunction(
        "AkKreuzung.setZeigeAnforderungenAlsInfo",
        function(param)
            AkKreuzung.setZeigeAnforderungenAlsInfo(param == "true")
        end
    )
    ServerController.addAcceptedRemoteFunction(
        "AkKreuzung.setZeigeSchaltungAlsInfo",
        function(param)
            AkKreuzung.setZeigeSchaltungAlsInfo(param == "true")
        end
    )
    ServerController.addAcceptedRemoteFunction(
        "AkKreuzung.setZeigeSignalIdsAllerSignale",
        function(param)
            AkKreuzung.setZeigeSignalIdsAllerSignale(param == "true")
        end
    )
    ServerController.addAcceptedRemoteFunction("AkKreuzungSchalteAutomatisch", AkKreuzung.schalteAutomatisch)
    ServerController.addAcceptedRemoteFunction("AkKreuzungSchalteManuell", AkKreuzung.schalteManuell)
end

return KreuzungWebConnector
