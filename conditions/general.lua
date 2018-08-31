local _, NeP = ...
local _G = _G

local function checkChanneling(target)
  local name, _, _, _, startTime, endTime, _, notInterruptible = _G.UnitChannelInfo(target)
  if name then return name, startTime, endTime, notInterruptible end
end

local function checkCasting(target)
  local name, startTime, endTime, notInterruptible = checkChanneling(target)
  if name then return name, startTime, endTime, notInterruptible end
  name, _,_,_, startTime, endTime, _,_, notInterruptible = _G.UnitCastingInfo(target)
  if name then return name, startTime, endTime, notInterruptible end
end

NeP.DSL:Register('true', function()
  return true
end)

NeP.DSL:Register('false', function()
  return false
end)

NeP.DSL:Register('timetomax', function(target)
  local max = _G.UnitPowerMax(target)
  local curr = _G.UnitPower(target)
  local regen = select(2, _G.GetPowerRegen(target))
  return (max - curr) * (1.0 / regen)
end)

NeP.DSL:Register('toggle', function(_, toggle)
  return NeP.Config:Read('TOGGLE_STATES', toggle:lower(), false)
end)

NeP.DSL:Register('casting.percent', function(target)
  local name, startTime, endTime, notInterruptible = checkCasting(target)
  if name and not notInterruptible then
    local castLength = (endTime - startTime) / 1000
    local secondsDone = _G.GetTime() - (startTime / 1000)
    return ((secondsDone/castLength)*100)
  end
  return 0
end)

NeP.DSL:Register('channeling.percent', function(target)
  local name, startTime, endTime, notInterruptible = checkChanneling(target)
  if name and not notInterruptible then
    local castLength = (endTime - startTime) / 1000
    local secondsDone = _G.GetTime() - (startTime / 1000)
    return ((secondsDone/castLength)*100)
  end
  return 0
end)

NeP.DSL:Register('casting.delta', function(target)
  local name, startTime, endTime, notInterruptible = checkCasting(target)
  if name and not notInterruptible then
    local castLength = (endTime - startTime) / 1000
    local secondsLeft = endTime / 1000 - _G.GetTime()
    return secondsLeft, castLength
  end
  return 0
end)

NeP.DSL:Register('channeling', function (target, spell)
  local name = checkChanneling(target)
  spell = NeP.Core:GetSpellName(spell)
  return spell and (name == spell)
end)

NeP.DSL:Register('casting', function(target, spell)
  local name = checkCasting(target)
  spell = NeP.Core:GetSpellName(spell)
  return spell and (name == spell)
end)

NeP.DSL:Register('interruptAt', function (target, spell)
  if _G.UnitIsUnit('player', target) then return false end
  if spell and NeP.DSL:Get('toggle')(nil, 'Interrupts') then
    local stopAt = (tonumber(spell) or 35) + math.random(-5, 5)
    local secondsLeft, castLength = NeP.DSL:Get('casting.delta')(target)
    return secondsLeft ~= 0 and (100 - (secondsLeft / castLength * 100)) > stopAt
  end
end)

NeP.DSL:Register('timeout', function(_, args)
  local name, time = _G.strsplit(',', args, 2)
  time = tonumber(time)
  if time then
    if NeP.timeOut.check(name) then return false end
    NeP.timeOut.set(name, time)
    return true
  end
end)

NeP.DSL:Register('isnear', function(target, args)
  local targetID, distance = _G.strsplit(',', args, 2)
  targetID = tonumber(targetID) or 0
  distance = tonumber(distance) or 60
  for _, Obj in pairs(NeP.OM:Get('Enemy')) do
    if Obj.id == targetID then
      return NeP.Protected.Distance('player', target) <= distance
    end
  end
end)

NeP.DSL:Register('gcd', function()
  local class = select(3,_G.UnitClass("player"))
  -- Some class's always have GCD = 1
  if class == 4
  or (class == 11 and _G.GetShapeshiftForm() == 2)
  or (class == 10 and _G.GetSpecialization() ~= 2) then
    return 1
  end
  return math.floor((1.5 / ((_G.GetHaste() / 100) + 1)) * 10^3 ) / 10^3
end)

NeP.DSL:Register('ui', function(_, args)
  local key, UI_key = _G.strsplit(",", args, 2)
  UI_key = UI_key or NeP.CR.CR.name
  return NeP.Interface:Fetch(UI_key, key)
end)
