local _, NeP = ...
local _G = _G
local strsplit = _G.strsplit
local IsInGroup = _G.IsInGroup
local IsInRaid = _G.IsInRaid
local GetNumGroupMembers = _G.GetNumGroupMembers

NeP.Protected = {}
NeP.Protected.callbacks = {}

local rangeCheck = _G.LibStub("LibRangeCheck-2.0")
local noop = function() end

function NeP.Protected.ObjectValid(Obj)
	return UnitInPhase(Obj)
	and UnitIsVisible(Obj)
	and NeP.Protected.Distance("player", Obj) < 50
	and NeP.Protected.LineOfSight("player", Obj)
end

function NeP.Protected:AddCallBack(func)
	if not func() then
		table.insert(self.callbacks, func)
	end
end

NeP.Protected.Cast = function(spell, target)
  NeP.Faceroll:Set(spell, target)
end

NeP.Protected.CastGround = function(spell, target)
  NeP.Faceroll:Set(spell, target)
end

NeP.Protected.Macro = noop
NeP.Protected.UseItem = noop
NeP.Protected.UseInvItem = noop
NeP.Protected.TargetUnit = noop
NeP.Protected.SpellStopCasting = noop
NeP.Protected.ObjectExists = noop
NeP.Protected.ObjectCreator = noop
NeP.Protected.GameObjectIsAnimating = noop

NeP.Protected.Distance = function(_, b)
  local minRange, maxRange = rangeCheck:GetRange(b)
  return maxRange or minRange or 0
end

NeP.Protected.Infront = function(_,b)
  return NeP.Helpers:Infront(b) or false
end

NeP.Protected.UnitCombatRange = function(_,b)
  return rangeCheck:GetRange(b) or 0
end

NeP.Protected.LineOfSight = function(_,b)
  return NeP.Helpers:Infront(b) or false
end

local ValidUnits = {'player', 'mouseover', 'target', 'focus', 'pet',}
local ValidUnitsN = {'boss', 'arena', 'arenapet'}

NeP.Protected.nPlates = {
	Friendly = {},
	Enemy = {}
}

function NeP.Protected.nPlates:Insert(ref, Obj, GUID)
	local distance = NeP.Protected.Distance('player', Obj) or 999
	if distance <= NeP.OM.max_distance then
		local ObjID = select(6, strsplit('-', GUID))
		self[ref][GUID] = {
			key = Obj,
			name = _G.UnitName(Obj),
			distance = distance,
			id = tonumber(ObjID or 0),
			guid = GUID,
			isdummy = NeP.DSL:Get('isdummy')(Obj)
		}
	end
end

NeP.Protected.OM_Maker = function()
  -- If in Group scan frames...
  if IsInGroup()
	or IsInRaid() then
    local prefix = (IsInRaid() and 'raid') or 'party'
    for i = 1, GetNumGroupMembers() do
      local unit = prefix..i
			local pet = prefix..'pet'..i
      NeP.OM:Add(unit)
			NeP.OM:Add(pet)
      NeP.OM:Add(unit..'target')
      NeP.OM:Add(pet..'target')
    end
  end
  -- Valid Units
  for i=1, #ValidUnits do
    local object = ValidUnits[i]
    NeP.OM:Add(object)
    NeP.OM:Add(object..'target')
  end
	-- Valid Units with numb (5)
	for i=1, #ValidUnitsN do
		for k=1, 5 do
			local object = ValidUnitsN[i]..k
			NeP.OM:Add(object)
			NeP.OM:Add(object..'target')
		end
	end
  --nameplates
	for i=1, 40 do
		local Obj = 'nameplate'..i
		if _G.UnitExists(Obj) then
			local GUID = _G.UnitGUID(Obj) or '0'
			if _G.UnitIsFriend('player',Obj) then
				NeP.Protected.nPlates:Insert('Friendly', Obj, GUID)
			else
				NeP.Protected.nPlates:Insert('Enemy', Obj, GUID)
			end
		end
	end
end
