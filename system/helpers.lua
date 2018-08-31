local _, NeP = ...
local _G = _G
NeP.Helpers = {}
local UIErrorsFrame = _G.UIErrorsFrame
local C_Timer = _G.C_Timer

local _Failed = {}

--this disables the error messages
UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")

local function addToData(GUID)
	if not _Failed[GUID] then
		_Failed[GUID] = {}
	end
end

local function blackListSpell(GUID, spell)
	_Failed[GUID][spell] =  true
	C_Timer.After(0.2, (function()
		_Failed[GUID][spell] =  nil
	end), nil)
end

local function blackListInfront(GUID)
	_Failed[GUID].infront = true
	C_Timer.After(0.5, (function()
		_Failed[GUID].infront = nil
	end), nil)
end

local UI_Erros = {
	[_G.ERR_SPELL_FAILED_S] = function(GUID, spell)
		blackListSpell(GUID, spell)
		blackListInfront(GUID)
	end,
	[_G.ERR_BADATTACKFACING] = function(GUID, spell)
		blackListSpell(GUID, spell)
		blackListInfront(GUID)
	end,
	[_G.ERR_SPELL_OUT_OF_RANGE] = function(GUID, spell) blackListSpell(GUID, spell) end,
	[_G.ERR_NOT_WHILE_MOVING] = function(GUID, spell) blackListSpell(GUID, spell) end,
	[_G.ERR_SPELL_FAILED_ANOTHER_IN_PROGRESS] = function(GUID, spell) blackListSpell(GUID, spell) end,
	[_G.ERR_SPELL_COOLDOWN] = function(GUID, spell) blackListSpell(GUID, spell) end,
	[_G.ERR_ABILITY_COOLDOWN] = function(GUID, spell) blackListSpell(GUID, spell) end,
	[_G.ERR_CANT_USE_ITEM] = function(GUID, spell) blackListSpell(GUID, spell) end,
	[_G.ERR_ITEM_COOLDOWN] = function(GUID, spell) blackListSpell(GUID, spell) end,
}

function NeP.Helpers.Infront(_, target, GUID)
	GUID = GUID or _G.UnitGUID(target)
	if _Failed[GUID] then
		 return not _Failed[GUID].infront
	end
	return true
end

function NeP.Helpers.Spell(_, spell, target, GUID)
	GUID = GUID or _G.UnitGUID(target)
	if _Failed[GUID] then
		 return not _Failed[GUID][spell]
	end
	return true
end

function NeP.Helpers:Check(spell, target)

	-- Both MUST be strings
	if type(spell) ~= 'string'
	or type(target) ~= 'string' then
		return true
	end

	local GUID = _G.UnitGUID(target)
	if _Failed[GUID] then
		return self:Spell(spell, target, GUID) and self:Infront(target, GUID)
	end

	return true
end

NeP.Listener:Add("NeP_Helpers", "UI_ERROR_MESSAGE", function(error)
	if not UI_Erros[error] then return end

	local unit, spell = NeP.Parser.LastTarget, NeP.Parser.LastCast
	if not unit or not spell then return end

	local GUID = _G.UnitGUID(unit)
	if GUID then
		addToData(GUID)
		UI_Erros[error](GUID, spell)
	end
end)
