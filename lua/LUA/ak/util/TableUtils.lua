if AkDebugLoad then print("[#Start] Loading ak.util.TableUtils ...") end
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

---Looks, if there are the same values in both arrays (ignoring the keys)
---@param t1 table
---@param t2 table
---@return boolean true if both contain the same values
function TableUtils.sameArrayEntries(t1, t2)
    local entries1 = {}
    for _, v1 in ipairs(t1) do entries1[v1] = true end
    local entries2 = {}
    for _, v2 in ipairs(t2) do
        if not entries1[v2] then return false end
        entries2[v2] = true
    end

    for k in pairs(entries1) do if not entries2[k] then return false end end
    return true
end

---Looks, if there are the same keys and values in both arrays
---@param t1 table
---@param t2 table
---@return boolean true if both contain the same values
function TableUtils.sameDictEntries(t1, t2)
    for k1, v1 in pairs(t1) do if not t2[k1] or t2[k1] ~= v1 then return false end end
    for k2, v2 in pairs(t2) do if not t1[k2] or t1[k2] ~= v2 then return false end end
    return true
end

local function deepDictCompare(t1, t2, ignore_mt)
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then return false end
    -- non-table types can be directly compared
    if ty1 ~= "table" and ty2 ~= "table" then return t1 == t2 end
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
function TableUtils.clearArray(array) for i = 1, #array, 1 do array[i] = nil end end

-- from http://lua-users.org/wiki/CopyTable
---@param orig table to be copied
function TableUtils.shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in pairs(orig) do copy[orig_key] = orig_value end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function TableUtils.valuesOfDict(dictionary)
    local newArray = {}
    if dictionary then for _, v in pairs(dictionary) do table.insert(newArray, v) end end
    return newArray
end

-- Get count of table entries
---@param t table
function TableUtils.length(t)
    local i = 0
    for _ in pairs(t) do i = i + 1 end
    return i
end

return TableUtils
