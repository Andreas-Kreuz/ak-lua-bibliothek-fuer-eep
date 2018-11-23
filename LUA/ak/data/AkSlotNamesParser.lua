local SlotNamesParser = {}

local function isModuleAvailable(name)
    if package.loaded[name] then
        return true
    else
        for _, searcher in ipairs(package.searchers or package.loaders) do
            local loader = searcher(name)
            if type(loader) == 'function' then
                package.preload[name] = loader
                return true
            end
        end
        return false
    end
end

local namesToSlots = {}
local slotTable
local _
local SlotFuncs

function SlotNamesParser.updateSlotNames()
    if slotTable then
        local function recursiveLookup(currentSlotTable, prefix, ...)
            for k, v in pairs(currentSlotTable) do
                local path = ... and { table.unpack(...) } or {}
                table.insert(path, k)
                local pathString = table.concat(path, ".")
                if type(v) == 'table' then
                    -- print(pathString .. '> Lookup Table '  .. pathString)
                    recursiveLookup(v, prefix .. "--", path)
                else
                    local slotNumber = SlotFuncs.lookupSlotNr(table.unpack(path))
                    -- print(pathString .. '> Found Slot: ' .. tostring(s))

                    namesToSlots[tostring(slotNumber)] = pathString
                end
            end
        end

        recursiveLookup(slotTable, '#', {})
    end
end

if isModuleAvailable('SlotNames_BH2') then
    slotTable, _, SlotFuncs = require('SlotNames_BH2')()
    SlotNamesParser.updateSlotNames()
end

function SlotNamesParser.getSlotName(slot)
    if slotTable then
        return namesToSlots[tostring(slot)]
    else
        return '?'
    end
end

return SlotNamesParser