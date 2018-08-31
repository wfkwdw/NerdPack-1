local _, NeP = ...
local _G = _G
local Roster = NeP.OM.Roster
local maxDistance = 40
NeP.Healing = {}

local forced_role = {
	[72218] = "TANK" -- Oto the Protector (Proving Grounds)
}

function NeP.Healing.GetPredictedHealth(unit)
	return _G.UnitHealth(unit)+(_G.UnitGetIncomingHeals(unit) or 0)
end

function NeP.Healing.GetPredictedHealth_Percent(unit)
	return math.floor((NeP.Healing.GetPredictedHealth(unit)/_G.UnitHealthMax(unit))*100)
end

function NeP.Healing.healthPercent(unit)
	return math.floor((_G.UnitHealth(unit)/_G.UnitHealthMax(unit))*100)
end

-- This Add's more index to the Obj in the OM table
local function Add(Obj)
	Obj.predicted = NeP.Healing.GetPredictedHealth_Percent(Obj.key)
	Obj.predicted_Raw = NeP.Healing.GetPredictedHealth(Obj.key)
	Obj.health = NeP.Healing.healthPercent(Obj.key)
	Obj.healthRaw = _G.UnitHealth(Obj.key)
	Obj.healthMax = _G.UnitHealthMax(Obj.key)
	Obj.role = forced_role[Obj.id] or _G.UnitGroupRolesAssigned(Obj.key)
	Roster[Obj.guid] = Obj
end

local function Iterate()
	_G.wipe(Roster)
	for _, Obj in pairs(NeP.OM:Get("Friendly")) do
		if Obj.distance < maxDistance
		and _G.UnitExists(Obj.key)
		and (_G.UnitInParty(Obj.key) or _G.UnitIsUnit("player", Obj.key))
		and not _G.UnitIsCharmed(Obj.key) then
			Add(Obj)
		end
	end
end

NeP.Debug:Add("Healing", Iterate, false)
C_Timer.NewTicker(0.5, Iterate)