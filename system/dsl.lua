local _, NeP = ...
local _G = _G
local DSL = NeP.DSL
local strsplit = _G.strsplit
DSL.cust_funcs = {}

local function FilterNum(str)
	local type_X = type(str)
	if type_X == 'string' then
		return tonumber(str) or 0
	elseif type_X == 'boolean' then
		return str and 1 or 0
	elseif type_X == 'number' then
		return str
	end
	return 0
end

local comperatores_OP = {
	['>='] = function(arg1, arg2) return arg1 >= arg2 end,
	['<='] = function(arg1, arg2) return arg1 <= arg2 end,
	['=='] = function(arg1, arg2) return arg1 == arg2 end,
	['~='] = function(arg1, arg2) return arg1 ~= arg2 end,
	['>']  = function(arg1, arg2) return arg1 > arg2 end,
	['<']  = function(arg1, arg2) return arg1 < arg2 end,
	['::']  = function(arg1, arg2) local a,b = strsplit(',', arg2); return arg1 > a and arg1 < b end
}

-- alias (LEGACY)
comperatores_OP['!='] = comperatores_OP['~=']
comperatores_OP['='] 	= comperatores_OP['==']

local math_OP = {
	['+']  = function(arg1, arg2) return arg1 + arg2 end,
	['-']  = function(arg1, arg2) return arg1 - arg2 end,
	['/']  = function(arg1, arg2) return arg1 / arg2 end,
	['*']  = function(arg1, arg2) return arg1 * arg2 end,
}

local DSL_OP = {
	['!']  = function(...) return not DSL.Parse(...) end,
	['@']  = function(arg,_,target) return NeP.Library:Parse(arg:gsub('%((.+)%)', ''), target, arg:match('%((.+)%)')) end,
}

local function _AND(strg, spell, target)
	local Arg1, Arg2 = strg:match('(.*)&(.*)')
	Arg1 = DSL.Parse(Arg1, spell, target)
	-- Dont process anything in front sence we already failed
	if not Arg1 then return Arg1 end
	Arg2 = DSL.Parse(Arg2, spell, target)
	return Arg1 and Arg2
end

local function _OR(strg, spell, target)
	local Arg1, Arg2 = strg:match('(.*)||(.*)')
	Arg1 = DSL.Parse(Arg1, spell)
	-- Dont process anything in front sence we already hit
	if Arg1 then return Arg1 end
	Arg2 = DSL.Parse(Arg2, spell, target)
	return Arg1 or Arg2
end

local function FindNest(strg)
	local Start, End = strg:find('({.*})')
	local count1, count2 = 0, 0
	for i=Start, End do
		local temp = strg:sub(i, i)
		if temp == "{" then
			count1 = count1 + 1
		elseif temp == "}" then
			count2 = count2 + 1
		end
		if count1 == count2 then
			return Start,  i
		end
	end
end

local function Nest(strg, spell, target)
	local Start, End = FindNest(strg)
	local Result = DSL.Parse(strg:sub(Start+1, End-1), spell, target)
	Result = tostring(Result or false)
	strg = strg:sub(1, Start-1)..Result..strg:sub(End+1)
	return DSL.Parse(strg, spell, target)
end

local C = NeP.Cache.Conditions

local function ProcessCondition(strg, spell, target)
	-- Unit prefix
	if not NeP.DSL:Exists(strg:gsub("%((.+)%)", "")) then
		local unitID, rest = _G.strsplit('.', strg, 2)
		unitID =  NeP.FakeUnits:Filter(unitID)[1]
		-- condition target
		if unitID
		and rest
		and _G.UnitExists(unitID) then
			target = unitID
			strg = rest
		else
			--escape early if the unit dosent exist
			return false
		end
	end
	-- Condition arguments
	local Args = strg:match("%((.+)%)") or spell
	strg = strg:gsub("%((.+)%)", "")
	target = target or 'player'

	C[strg] = C[strg] or {}
	C[strg][target] = C[strg][target] or {}
	if C[strg][target][Args] == nil then
		C[strg][target][Args] = DSL:Get(strg)(target, Args) or false
	end

	return C[strg][target][Args]
end

local function Comperatores(strg, spell, target)
	local OP = ''
	--Need to scan for != seperately otherwise we get false positives by spells with "!" in them
	if strg:find('!=') then
		OP = '!='
	else
		for Token in strg:gmatch('[><=~!]') do OP = OP..Token end
	end
	--escape early if invalid token
	local func = comperatores_OP[OP]
	if not func then return false end
	--actual process
	local arg1, arg2 = strg:match("(.*)"..OP.."(.*)")
	arg1 = DSL.Parse(arg1, spell, target)
	arg2 = DSL.Parse(arg2, spell, target)
	arg1 = FilterNum(arg1)
	arg2 = FilterNum(arg2)
	return func(arg1 or 1, arg2 or 1)
end

local function StringMath(strg, spell, target)
	local tokens = "[/%*%+%-]"
	local OP = strg:match(tokens)
	local arg1, arg2 = _G.strsplit(OP, strg, 2)
	arg1 = DSL.Parse(arg1, spell, target)
	arg2 = DSL.Parse(arg2, spell, target)
	arg1 = FilterNum(arg1)
	arg2 = FilterNum(arg2)
	return math_OP[OP](arg1, arg2)
end

local function ExeFunc(strg)
	local Args = strg:match('%((.+)%)')
	strg = strg:gsub('%((.+)%)', '')
	return DSL.cust_funcs[strg](Args)
end

function NeP.DSL.Parse(strg, spell, target)
	local pX = strg:sub(1, 1)
	if strg:find('{(.-)}') then
		return Nest(strg, spell, target)
	elseif strg:find('||') then
		return _OR(strg, spell, target)
	elseif strg:find('&') then
		return _AND(strg, spell, target)
	elseif DSL_OP[pX] then
		strg = strg:sub(2);
		return DSL_OP[pX](strg, spell, target)
	elseif strg:find("func=") then
		strg = strg:sub(6);
		return ExeFunc(strg)
	-- != needs to be seperate otherwise we end up with false positives
	elseif strg:find('[><=~]') or strg:find('!=') then
		return Comperatores(strg, spell, target)
	elseif strg:find("[/%*%+%-]") then
		return StringMath(strg, spell, target)
	elseif strg:find('^%a') then
		return ProcessCondition(strg, spell, target)
	end
	return strg
end
