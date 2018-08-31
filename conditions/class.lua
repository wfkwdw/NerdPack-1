local _, NeP = ...
local _G = _G

NeP.DSL:Register('energy', function(target)
  return _G.UnitPower(target, _G.UnitPowerType(target))
end)

-- Returns the amount of energy you have left till max
-- (e.g. you have a max of 100 energy and 80 energy now, so it will return 20)
NeP.DSL:Register('energydiff', function(target)
  local max = _G.UnitPowerMax(target, _G.UnitPowerType(target))
  local curr = _G.UnitPower(target, _G.UnitPowerType(target))
  return (max - curr)
end)

NeP.DSL:Register('mana', function(target)
  if _G.UnitExists(target) then
    return math.floor((_G.UnitMana(target) / _G.UnitManaMax(target)) * 100)
  end
  return 0
end)

NeP.DSL:Register('insanity', function(target)
  return _G.UnitPower(target, _G.SPELL_POWER_INSANITY)
end)

NeP.DSL:Register('petrange', function(target)
  return target and NeP.Protected.Distance('pet', target) or 0
end)

NeP.DSL:Register('focus', function(target)
  return _G.UnitPower(target, _G.SPELL_POWER_FOCUS)
end)

NeP.DSL:Register('runicpower', function(target)
  return _G.UnitPower(target, _G.SPELL_POWER_RUNIC_POWER)
end)

NeP.DSL:Register('runes', function()
  local count = 0
  local next = 0
  for i = 1, 6 do
    local _, duration, runeReady = _G.GetRuneCooldown(i)
    if runeReady then
      count = count + 1
    elseif duration > next then
      next = duration
    end
  end
  if next > 0 then count = count + (next / 10) end
  return count
end)

NeP.DSL:Register('maelstrom', function(target)
  return _G.UnitPower(target, _G.SPELL_POWER_MAELSTROM)
end)

NeP.DSL:Register('totem', function(_, totem)
  for index = 1, 4 do
    local totemName = select(2, _G.GetTotemInfo(index))
    if totemName == NeP.Core:GetSpellName(totem) then
      return true
    end
  end
  return false
end)

NeP.DSL:Register('totem.duration', function(_, totem)
  for index = 1, 4 do
    local _, totemName, startTime, duration = _G.GetTotemInfo(index)
    if totemName == NeP.Core:GetSpellName(totem) then
      return math.floor(startTime + duration - _G.GetTime())
    end
  end
  return 0
end)

NeP.DSL:Register('totem.time', function(_, totem)
  for index = 1, 4 do
    local _, totemName, _, duration = _G.GetTotemInfo(index)
    if totemName == NeP.Core:GetSpellName(totem) then
      return duration
    end
  end
  return 0
end)

NeP.DSL:Register('soulshards', function(target)
  return _G.UnitPower(target, _G.SPELL_POWER_SOUL_SHARDS)
end)

NeP.DSL:Register('chi', function(target)
  return _G.UnitPower(target, _G.SPELL_POWER_CHI)
end)

-- Returns the number of chi you have left till max (e.g. you have a max of 5 chi and 3 chi now, so it will return 2)
NeP.DSL:Register('chidiff', function(target)
  local max = _G.UnitPowerMax(target, _G.SPELL_POWER_CHI)
  local curr = _G.UnitPower(target, _G.SPELL_POWER_CHI)
  return (max - curr)
end)

NeP.DSL:Register('form', function()
  return _G.GetShapeshiftForm()
end)

NeP.DSL:Register('lunarpower', function(target)
  return _G.UnitPower(target, _G.SPELL_POWER_LUNAR_POWER)
end)

NeP.DSL:Register('mushrooms', function()
  local count = 0
  for slot = 1, 3 do
    if _G.GetTotemInfo(slot) then
      count = count + 1 end
  end
  return count
end)

NeP.DSL:Register('holypower', function(target)
  return _G.UnitPower(target, _G.SPELL_POWER_HOLY_POWER)
end)

NeP.DSL:Register('rage', function(target)
  return _G.UnitPower(target, _G.SPELL_POWER_RAGE)
end)

NeP.DSL:Register('stance', function()
  return _G.GetShapeshiftForm()
end)

NeP.DSL:Register('fury', function(target)
  return _G.UnitPower(target, _G.SPELL_POWER_FURY)
end)

-- Returns the number of fury you have left till max (e.g. you have a max of 100 fury and 80 fury now,
-- so it will return 20)
NeP.DSL:Register('fury.diff', function(target)
  local max = _G.UnitPowerMax(target, _G.SPELL_POWER_FURY)
  local curr = _G.UnitPower(target, _G.SPELL_POWER_FURY)
  return (max - curr)
end)

NeP.DSL:Register('pain', function(target)
  return _G.UnitPower(target, _G.SPELL_POWER_PAIN)
end)

NeP.DSL:Register('arcanecharges', function(target)
  return _G.UnitPower(target, _G.SPELL_POWER_ARCANE_CHARGES)
end)

NeP.DSL:Register('combopoints', function(target)
  return _G.UnitPower(target, _G.SPELL_POWER_COMBO_POINTS)
end)

--This should be replaced by ids
local minions = {
  count = 0,
  empower = {},
  empower_count = 0,
  ["Wild Imp"] = 12,
  Dreadstalker = 12,
  Imp = 25,
  Felhunter = 25,
  Succubus = 25,
  Felguard = 25,
  Darkglare = 12,
  Doomguard = 25,
  Infernal = 25,
  Voidwalker = 25
}

NeP.Listener:Add('lock_P', 'COMBAT_LOG_EVENT_UNFILTERED', function(_, event, _,_, sName, _,_, dGUID, dName, _,_, sid)
  if not sName == _G.UnitName("player")
  or not minions[dName] then return end

  -- Count active
  if event == "SPELL_SUMMON" then
    minions.count = minions.count + 1
    -- removes the unit after it expires
    _G.C_Timer.After(minions[dName], function()
      minions.count = minions.count - 1
      if minions.empower[dGUID] then
        minions.empower[dGUID] = nil
        minions.empower_count = minions.empower_count - 1
      end
    end)
  end

  -- Count units with Empower
  if (event == "SPELL_AURA_APPLIED"
  or event == "SPELL_AURA_REFRESH")
  and sid == 193396 then
    minions.empower[dGUID] = true
    minions.empower_count = minions.empower_count + 1
  end

end)

NeP.DSL:Register('warlock.minions', function()
  return minions.count
end)

NeP.DSL:Register('warlock.empower', function()
  return minions.empower_count
end)
NeP.DSL:Register('warlock.empower.missing', function()
  return minions.count - minions.empower_count
end)
