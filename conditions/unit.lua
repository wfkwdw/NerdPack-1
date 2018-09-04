local _, NeP = ...

NeP.DSL:Register('ingroup', function(target)
  return UnitInParty(target) or UnitInRaid(target)
end)

NeP.DSL:Register('group.members', function()
  return (GetNumGroupMembers() or 0)
end)

-- USAGE: group.type==#
-- * 3 = RAID
-- * 2 = Party
-- * 1 = SOLO
NeP.DSL:Register('group.type', function()
  return IsInRaid() and 3 or IsInGroup() and 2 or 1
end)

local UnitClsf = {
  ['elite'] = 2,
  ['rareelite'] = 3,
  ['rare'] = 4,
  ['worldboss'] = 5
}

NeP.DSL:Register("boss", function (target)
  if NeP.DSL:Get("isdummy")(target) then return end
  local classification = UnitClassification(target)
  if UnitClsf[classification] then
    return UnitClsf[classification] >= 3 or NeP.BossID:Eval(target)
  end
end)

NeP.DSL:Register('elite', function (target)
  local classification = UnitClassification(target)
  if UnitClsf[classification] then
    return UnitClsf[classification] >= 2
  end
  return NeP.BossID:Eval(target)
end)

NeP.DSL:Register('id', function(target, id)
  local expectedID = tonumber(id)
  return expectedID and NeP.Core:UnitID(target) == expectedID
end)

NeP.DSL:Register('threat', function(target)
  if UnitThreatSituation('player', target) then
    return select(3, UnitDetailedThreatSituation('player', target))
  end
  return 0
end)

NeP.DSL:Register('aggro', function(target)
  return (UnitThreatSituation(target) and UnitThreatSituation(target) >= 2)
end)

NeP.DSL:Register('moving', function(target)
  local speed, _ = GetUnitSpeed(target)
  return speed ~= 0
end)

NeP.DSL:Register('classification', function (target, spell)
  if not spell then return false end
  local classification = UnitClassification(target)
  if string.find(spell, '[%s,]+') then
    for classificationExpected in string.gmatch(spell, '%a+') do
      if classification == string.lower(classificationExpected) then
        return true
      end
    end
    return false
  else
    return UnitClassification(target) == string.lower(spell)
  end
end)

NeP.DSL:Register('target', function(target, spell)
  return ( UnitGUID(target .. 'target') == UnitGUID(spell) )
end)

NeP.DSL:Register('player', function(target)
  return UnitIsPlayer(target)
end)

NeP.DSL:Register('exists', function(target)
  return UnitExists(target)
end)

NeP.DSL:Register('dead', function (target)
  return UnitIsDeadOrGhost(target)
end)

NeP.DSL:Register('alive', function(target)
  return not UnitIsDeadOrGhost(target)
end)

NeP.DSL:Register('behind', function(target)
  return not NeP.Protected.Infront('player', target)
end)

NeP.DSL:Register('infront', function(target)
  return NeP.Protected.Infront('player', target)
end)

local movingCache = {}

NeP.DSL:Register('lastmoved', function(target)
  if UnitExists(target) then
    local guid = UnitGUID(target)
    if movingCache[guid] then
      local moving = (GetUnitSpeed(target) > 0)
      if not movingCache[guid].moving and moving then
        movingCache[guid].last = GetTime()
        movingCache[guid].moving = true
        return false
      elseif moving then
        return false
      elseif not moving then
        movingCache[guid].moving = false
        return GetTime() - movingCache[guid].last
      end
    else
      movingCache[guid] = { }
      movingCache[guid].last = GetTime()
      movingCache[guid].moving = (GetUnitSpeed(target) > 0)
      return false
    end
  end
  return false
end)

NeP.DSL:Register('movingfor', function(target)
  if UnitExists(target) then
    local guid = UnitGUID(target)
    if movingCache[guid] then
      local moving = (GetUnitSpeed(target) > 0)
      if not movingCache[guid].moving then
        movingCache[guid].last = GetTime()
        movingCache[guid].moving = (GetUnitSpeed(target) > 0)
        return 0
      elseif moving then
        return GetTime() - movingCache[guid].last
      elseif not moving then
        movingCache[guid].moving = false
        return 0
      end
    else
      movingCache[guid] = { }
      movingCache[guid].last = GetTime()
      movingCache[guid].moving = (GetUnitSpeed(target) > 0)
      return 0
    end
  end
  return 0
end)

NeP.DSL:Register('friend', function(target)
  return not UnitCanAttack('player', target)
end)

NeP.DSL:Register('enemy', function(target)
  return UnitCanAttack('player', target)
end)

NeP.DSL:Register({'distance', 'range'}, function(unit)
  return NeP.Protected.UnitCombatRange('player', unit)
end)

NeP.DSL:Register({'distancefrom', 'rangefrom'}, function(unit, unit2)
  return NeP.Protected.UnitCombatRange(unit, unit2)
end)

NeP.DSL:Register('level', function(target)
  return UnitLevel(target)
end)

NeP.DSL:Register('combat', function(target)
  return UnitAffectingCombat(target)
end)

-- Checks if the player has autoattack toggled currently
-- Use {'/startattack', '!isattacking'}, at the top of a CR to force autoattacks
NeP.DSL:Register('isattacking', function()
  return IsCurrentSpell(6603)
end)

NeP.DSL:Register('role', function(target, role)
  return role:upper() == UnitGroupRolesAssigned(target)
end)

NeP.DSL:Register('name', function (target, expectedName)
  return UnitName(target):lower():find(expectedName:lower()) ~= nil
end)

NeP.DSL:Register('creatureType', function (target, expectedType)
  return UnitCreatureType(target) == expectedType
end)

NeP.DSL:Register('class', function (target, expectedClass)
  local class, _, classID = UnitClass(target)
  if tonumber(expectedClass) then
    return tonumber(expectedClass) == classID
  else
    return expectedClass == class
  end
end)

NeP.DSL:Register('inmelee', function(target)
  local range = NeP.Protected.UnitCombatRange('player', target)
  return range <= 1.6, range
end)

NeP.DSL:Register('inranged', function(target)
  local range = NeP.Protected.UnitCombatRange('player', target)
  return range <= 40, range
end)

NeP.DSL:Register('incdmg', function(target, args)
  if args and UnitExists(target) then
    local pDMG = NeP.CombatTracker:getDMG(target)
    return pDMG * tonumber(args)
  end
  return 0
end)

NeP.DSL:Register('incdmg.phys', function(target, args)
  if args and UnitExists(target) then
    local pDMG = select(3, NeP.CombatTracker:getDMG(target))
    return pDMG * tonumber(args)
  end
  return 0
end)

NeP.DSL:Register('incdmg.magic', function(target, args)
  if args and UnitExists(target) then
    local mDMG = select(4, NeP.CombatTracker:getDMG(target))
    return mDMG * tonumber(args)
  end
  return 0
end)

NeP.DSL:Register('swimming', function ()
  return IsSwimming()
end)

--return if a unit is a unit
NeP.DSL:Register('is', function(a,b)
  return UnitIsUnit(a,b)
end)

NeP.DSL:Register("falling", function()
  return IsFalling()
end)

NeP.DSL:Register({"deathin", "ttd", "timetodie"}, function(target)
  if NeP.DSL:Get("isdummy")(target) then return 999
  else return NeP.CombatTracker:TimeToDie(target) end
end)

NeP.DSL:Register("charmed", function(target)
  return UnitIsCharmed(target)
end)

local communName = NeP.Locale:TA('Dummies', 'Name')
local matchs = NeP.Locale:TA('Dummies', 'Pattern')

NeP.DSL:Register('isdummy', function(unit)
  if not UnitExists(unit) then return end
  if UnitName(unit):lower():find(communName) then return true end
  return NeP.Tooltip:Unit(unit, matchs)
end)

NeP.DSL:Register('indoors', function()
    return IsIndoors()
end)

NeP.DSL:Register('haste', function(unit)
  return UnitSpellHaste(unit)
end)

NeP.DSL:Register("mounted", function()
  return IsMounted()
end)

NeP.DSL:Register('combat.time', function(target)
  return NeP.CombatTracker:CombatTime(target)
end)

NeP.DSL:Register('los', function(a, b)
  return NeP.Protected.LineOfSight(a, b)
end)
