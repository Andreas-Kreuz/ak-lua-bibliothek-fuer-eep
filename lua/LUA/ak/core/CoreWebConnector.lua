if AkDebugLoad then print("[#Start] Loading ak.core.CoreWebConnector ...") end
local CoreWebConnector = {}
local ServerController = require("ak.io.ServerController")
local registeredLuaModules = nil
function CoreWebConnector.setRegisteredLuaModules(modules) registeredLuaModules = modules end

function CoreWebConnector.registerJsonCollectors()
    local ModulesJsonCollector = require("ak.core.ModulesJsonCollector")
    local VersionJsonCollector = require("ak.core.VersionJsonCollector")
    ModulesJsonCollector.setRegisteredLuaModules(registeredLuaModules)
    ServerController.addJsonCollector(ModulesJsonCollector)
    ServerController.addJsonCollector(VersionJsonCollector)
end

return CoreWebConnector
