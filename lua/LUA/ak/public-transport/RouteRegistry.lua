local EventBroker = require "ak.util.EventBroker"
local Route = require "ak.public-transport.Route"
local RouteRegistry = {}
local allRoutes = {}

---Creates a route object for the given route name, the route must exist
---@param id string name of the route in EEP, e.g. "Taxi" or "Neue Route"
---@return Route,boolean returns the route and the status if the route was newly created
function RouteRegistry.forId(id)
    assert(id, "Provide an id for the route")
    assert(type(id) == "string", "Need 'routeName' as string")
    if allRoutes[id] then
        return allRoutes[id], false
    else
        -- Initialize the route
        local route = Route:new({routeName = id})
        allRoutes[route.id] = route
        return route, true
    end
end

---A route appeared on the map
function RouteRegistry.routeAppeared(_)
    -- is included in "RouteRegistry.fireChangeRoutesEvent()"
    -- EventBroker.fireDataAdded("routes", "id", route:toJsonStatic())
end

---A route dissappeared from the map
---@param routeName string
function RouteRegistry.routeDisappeared(routeName)
    allRoutes[routeName] = nil
    EventBroker.fireDataRemoved("public-transport-lines", "id", {id = routeName})
end

function RouteRegistry.fireChangeRoutesEvent()
    local modifiedRoutes = {}
    for _, route in pairs(allRoutes) do
        if route.valuesUpdated then
            modifiedRoutes[route.id] = route:toJsonStatic()
            route.valuesUpdated = false
        end
    end
    EventBroker.fireListChange("public-transport-lines", "id", modifiedRoutes)
end

return RouteRegistry
