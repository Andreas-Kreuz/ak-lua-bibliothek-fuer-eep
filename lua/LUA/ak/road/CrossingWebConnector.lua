if AkDebugLoad then print("Loading ak.road.CrossingWebConnector ...") end
local ServerController = require("ak.io.ServerController")
local Crossing = require("ak.road.Crossing")

---@class CrossingWebConnector
local CrossingWebConnector = {}

function CrossingWebConnector.registerJsonCollectors()
    ServerController.addJsonCollector(require("ak.road.TrafficLightModelJsonCollector"))
    ServerController.addJsonCollector(require("ak.road.CrossingJsonCollector"))
end

function CrossingWebConnector.registerFunctions()
    ServerController.addAcceptedRemoteFunction(
        "Crossing.setZeigeAnforderungenAlsInfo",
        function(param)
            Crossing.setZeigeAnforderungenAlsInfo(param == "true")
        end
    )
    ServerController.addAcceptedRemoteFunction(
        "Crossing.setZeigeSchaltungAlsInfo",
        function(param)
            Crossing.setZeigeSchaltungAlsInfo(param == "true")
        end
    )
    ServerController.addAcceptedRemoteFunction(
        "Crossing.setZeigeSignalIdsAllerSignale",
        function(param)
            Crossing.setZeigeSignalIdsAllerSignale(param == "true")
        end
    )
    ServerController.addAcceptedRemoteFunction("AkKreuzungSchalteAutomatisch", Crossing.schalteAutomatisch)
    ServerController.addAcceptedRemoteFunction("AkKreuzungSchalteManuell", Crossing.schalteManuell)
end

return CrossingWebConnector
