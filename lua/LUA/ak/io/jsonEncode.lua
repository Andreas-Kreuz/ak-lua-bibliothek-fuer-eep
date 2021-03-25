if AkDebugLoad then print("Loading ak.io.jsonEncode ...") end
--
-- jsonEncode.lua 
-- Simplified and fast version omitting any checks

--[[ Test für Anlage "Enkel_ANLAGE_Flughafen"

json.lua
time is 5123 ms --- waitForServer: 0 ms, initialize: 1600 ms, commands:  0 ms, collect: 236 ms,  expand:  13 ms  encode: 3193 ms  write:  81 ms
time is 3544 ms --- waitForServer: 0 ms, initialize:    0 ms, commands:  0 ms, collect: 215 ms,  expand:  11 ms  encode: 3217 ms  write: 101 ms
time is 3961 ms --- waitForServer: 0 ms, initialize:    0 ms, commands:  0 ms, collect: 308 ms,  expand:  18 ms  encode: 3540 ms  write:  95 ms
time is 4456 ms --- waitForServer: 0 ms, initialize:    0 ms, commands:  0 ms, collect: 282 ms,  expand:   9 ms  encode: 4064 ms  write: 101 ms
time is 4821 ms --- waitForServer: 0 ms, initialize:    0 ms, commands:  1 ms, collect: 343 ms,  expand:  17 ms  encode: 4365 ms  write: 95 ms

jsonEncode.lua
time is 5007 ms --- waitForServer: 0 ms, initialize: 2444 ms, commands:  0 ms, collect: 312 ms,  expand:   9 ms  encode: 2127 ms  write: 115 ms
time is 2512 ms --- waitForServer: 0 ms, initialize:    0 ms, commands:  1 ms, collect: 287 ms,  expand:  18 ms  encode: 2108 ms  write:  98 ms
time is 2844 ms --- waitForServer: 0 ms, initialize:    0 ms, commands:  0 ms, collect: 280 ms,  expand:  14 ms  encode: 2451 ms  write:  99 ms
time is 3193 ms --- waitForServer: 0 ms, initialize:    0 ms, commands:  0 ms, collect: 298 ms,  expand:  12 ms  encode: 2775 ms  write: 108 ms
time is 3363 ms --- waitForServer: 0 ms, initialize:    0 ms, commands:  0 ms, collect: 348 ms,  expand:  28 ms  encode: 2847 ms  write: 140 ms
time is 3205 ms --- waitForServer: 0 ms, initialize:    0 ms, commands:  0 ms, collect: 333 ms,  expand:  29 ms  encode: 2723 ms  write: 120 ms

-> Beim encode-Schritt wird ca 1/3 der benötigten Zeit eingespart.
--]]

local json = { _version = "1.0.0" }

-- local alias names increase performance
local type, tostring, pairs, ipairs, next, table_insert, table_concat
	= type, tostring, pairs, ipairs, next, table.insert, table.concat

-------------------------------------------------------------------------------
-- Encode
-------------------------------------------------------------------------------

local encode -- forward declaration

local result = {}

-- append entry
local function cat(str)
--	table_insert(result, str)	-- same speed
	result[#result + 1] = str	-- as this command
end	

-- replace last entry
local function rep(str)
	result[#result] = str
end	

local function encodeTable(tab)
    if tab[1] ~= nil then
        -- Encode array
		cat( "[" )
        for i, value in ipairs(tab) do
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
			if     type(value) == "string" then
				cat( string.format('"%s":"%s"', key, value) )
				
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

local function encodeString(str)
	cat( '"' .. str .. '"' )
end

local function encodeNumber(num)
	cat( tostring(num) )
end

local function encodeBoolean(bool)
	cat( tostring(bool) )
end

local function encodeNil(value)
	cat( "null" )
end

local type_func_map = {
    [ "table"   ] = encodeTable,
    [ "string"  ] = encodeString,
    [ "number"  ] = encodeNumber,
    [ "boolean" ] = encodeBoolean,
    [ "nil"     ] = encodeNil,
}

encode = function(value)
    local t = type(value)
    local f = type_func_map[t]
    if f then
        return f(value)
    end
    error("unexpected type '" .. t .. "'")
end

function json.encode(value)
	result = {}

local t0 = os.clock()
	
	encode(value) -- this is the slow part

local t1 = os.clock()

    local jsonString = table_concat(result)	-- this is very fast

local t2 = os.clock()
print(string.format("json.Encode: concat %d lines into %d characters, encode in %.3f sec, concat in %.3f sec", 
	#result, #jsonString, t1-t0, t2-t1
)
	
	return jsonString 
end

return json
