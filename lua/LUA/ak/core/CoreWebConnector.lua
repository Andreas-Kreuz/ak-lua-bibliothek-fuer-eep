if AkDebugLoad then print("[#Start] Loading ak.core.CoreWebConnector ...") end
local CoreWebConnector = {}
local ServerController = require("ak.io.ServerController")
local registeredLuaModules = nil
function CoreWebConnector.setRegisteredLuaModules(modules) registeredLuaModules = modules end

function CoreWebConnector.registerStatePublishers()
    local ModulesStatePublisher = require("ak.core.ModulesStatePublisher")
    local VersionStatePublisher = require("ak.core.VersionStatePublisher")
    ModulesStatePublisher.setRegisteredLuaModules(registeredLuaModules)
    ServerController.addStatePublisher(ModulesStatePublisher)
    ServerController.addStatePublisher(VersionStatePublisher)
end

return CoreWebConnector
