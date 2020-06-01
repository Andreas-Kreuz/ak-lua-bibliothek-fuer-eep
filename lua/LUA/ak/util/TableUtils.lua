local TableUtils = {}

---Creates are read-only table by wrapping the current table into a proxy.
---@param tb table
function TableUtils.readOnlyTable(tb)
    local proxy = {}
    local mt = { -- create metatable
        __index = tb,
        __newindex = function(_, _, _) error("attempt to update a read-only table", 2) end
    }
    setmetatable(proxy, mt)
    return proxy
end

function TableUtils.sameListEntries(t1, t2)
    local entries1 = {}
    for _, v1 in ipairs(t1) do entries1[v1] = true end
    local entries2 = {}
    for _, v2 in ipairs(t2) do
        if not entries1[v2] then return false end
        entries2.v2 = true
    end

    for k in pairs(entries1) do if not entries2[k] then return false end end
    return true
end

local function deepDictCompare(t1, t2, ignore_mt)
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then return false end
    -- non-table types can be directly compared
    if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
    -- as well as tables which have the metamethod __eq
    local mt = getmetatable(t1)
    if not ignore_mt and mt and mt.__eq then return t1 == t2 end
    for k1, v1 in pairs(t1) do
        local v2 = t2[k1]
        if v2 == nil or not deepDictCompare(v1, v2) then return false end
    end
    for k2, v2 in pairs(t2) do
        local v1 = t1[k2]
        if v1 == nil or not deepDictCompare(v1, v2) then return false end
    end
    return true
end
TableUtils.deepDictCompare = deepDictCompare

---@param array table
function TableUtils.clearArray(array)
    for i = 1, #array, 1 do
        array[i] = nil
    end
end

return TableUtils
