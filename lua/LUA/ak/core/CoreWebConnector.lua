if AkDebugLoad then print("[#Start] Loading ak.core.CoreWebConnector ...") end
local CoreWebConnector = {}
local ServerController = require("ak.io.ServerController")
local registeredLuaModules = nil
function CoreWebConnector.setRegisteredLuaModules(modules) registeredLuaModules = modules end

function CoreWebConnector.registerJsonCollectors()
    local ModulesJsonCollector = require("ak.core.ModulesJsonCollector")
    ModulesJsonCollector.setRegisteredLuaModules(registeredLuaModules)
    ServerController.addJsonCollector(ModulesJsonCollector)
    ServerController.addJsonCollector(require("ak.core.VersionJsonCollector"))
end

return CoreWebConnector
