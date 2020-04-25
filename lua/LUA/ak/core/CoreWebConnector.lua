print("Lade ak.core.CoreWebConnector ...")
local CoreWebConnector = {}
local ServerController = require("ak.io.ServerController")
local knownModules = nil
function CoreWebConnector.setRegisteredLuaModules(registeredLuaModules)
    knownModules = registeredLuaModules
end

function CoreWebConnector.registerJsonCollectors()
    local ModulesJsonCollector = require("ak.core.ModulesJsonCollector")
    ModulesJsonCollector.setRegisteredLuaModules(knownModules)
    ServerController.addJsonCollector(ModulesJsonCollector)
    ServerController.addJsonCollector(require("ak.core.VersionJsonCollector"))
end

return CoreWebConnector
