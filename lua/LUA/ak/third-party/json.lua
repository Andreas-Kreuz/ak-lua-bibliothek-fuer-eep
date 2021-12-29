if AkDebugLoad then print("Loading ak.io.json (optimized version) ...") end
--
-- json.lua
-- Simplified and faster version of the encode function based on json.lua from 2018 rxi
-- This version uses table.concat instead of concatenating strings.
-- No cycle checks!

local json = { _version = "1.0.0" }

-- local alias names increase performance
local type, tostring, pairs, ipairs, next, table_concat --, table_insert
    = type, tostring, pairs, ipairs, next, table.concat --, table.insert

-------------------------------------------------------------------------------
-- Encode
-------------------------------------------------------------------------------

local encode -- forward declaration

local result = {}

-- append entry
local function cat(str)
    --table_insert(result, str) -- same speed
    result[#result + 1] = str   -- as this command
end

-- replace last entry
local function rep(str)
    result[#result] = str
end

local escape_char_map = {
    [ "\\" ] = "\\\\",
    [ "\"" ] = "\\\"",
    [ "\b" ] = "\\b",
    [ "\f" ] = "\\f",
    [ "\n" ] = "\\n",
    [ "\r" ] = "\\r",
    [ "\t" ] = "\\t",
}

local function escape_char(c)
    return escape_char_map[c] or string.format("\\u%04x", c:byte())
end

local function escape_string(s)
    return s:gsub('[%z\1-\31\\"]', escape_char)
end

local function encode_nil(val)
    cat( "null" )
end

local function encode_table(tab)
    -- Caution: no check for circular reference!
	
    if tab[1] ~= nil then
        -- Encode array
        cat( "[" )
        for _, value in ipairs(tab) do
            encode(value)
            cat( "," )
        end
        rep( "]" ) -- replace last colon
        return

    elseif next(tab) ~= nil then
        -- Encode object
        cat( "{" )
        for key, value in pairs(tab) do
            --encode(key)
            --cat( ":" )
            --encode(value)
            -- It's faster to skip the last level of recursion
			-- Caution: Let's assume that key do not contain special characters
            if     type(value) == "string" then
                cat( string.format('"%s":"%s"', key, escape_string(value)) )

            elseif type(value) == "number" then -- Differentiate between integer and float
                cat( string.format(( value == math.floor(value) and '"%s":%d' or '"%s":%.3f' ), key, value) )
            else
                cat( string.format('"%s":', key) )
                encode(value)
            end
            cat( "," )
        end
        rep( "}" ) -- replace last colon
        return

    else
        -- Encode empty table
        cat( "[]" )
        return
    end
end

local function encode_string(val)
    cat( '"' .. escape_string(val) .. '"' ) -- special characters in val could break json
end

local function encode_number(val)
    -- Check for NaN, -inf and inf
    --if val ~= val or val <= -math.huge or val >= math.huge then
    --    error("unexpected number value '" .. tostring(val) .. "'")
    --end
    cat( tostring(val) )
end

local function encode_boolean(val)
    cat( tostring(val) )
end

local type_func_map = {
    [ "nil"     ] = encode_nil,
    [ "table"   ] = encode_table,
    [ "string"  ] = encode_string,
    [ "number"  ] = encode_number,
    [ "boolean" ] = encode_boolean,
}

encode = function(val)
    local t = type(val)
    local f = type_func_map[t]
    if f then
        return f(val)
    end
    error("unexpected type '" .. t .. "'")
end

function json.encode(val)
    result = {}

    local t0 = os.clock()

    encode(val) -- this is the slow part

    local t1 = os.clock()

    local jsonString = table_concat(result) -- this is very fast

    if AkDebug then 
	    local t2 = os.clock()
        print(string.format("json.Encode: concat %d lines into %d characters, encode in %.3f sec, concat in %.3f sec",
            #result, #jsonString, t1-t0, t2-t1
        ))
    end		

    return jsonString
end

return json
