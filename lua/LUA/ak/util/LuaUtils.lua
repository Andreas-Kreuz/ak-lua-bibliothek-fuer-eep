local LuaUtils = {}

---Creates are read-only table by wrapping the current table into a proxy.
---@param tb table
function LuaUtils.readOnlyTable(tb)
    local proxy = {}
    local mt = { -- create metatable
        __index = tb,
        __newindex = function(_, _, _) error("attempt to update a read-only table", 2) end
    }
    setmetatable(proxy, mt)
    return proxy
end

return LuaUtils
