local _, NeP = ...
local _G = _G

-- USAGE: UNIT.area(DISTANCE).enemies >= #
NeP.DSL:Register("area.enemies", function(unit, distance)
  if not UnitExists(unit) then return 0 end
  local total = 0
  for _, Obj in pairs(NeP.OM:Get("Enemy", true)) do
    if (_G.UnitAffectingCombat(Obj.key) or Obj.isdummy)
     and NeP.Protected.Distance(unit, Obj.key) <= tonumber(distance) then
      total = total +1
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).enemies.infront >= #
NeP.DSL:Register("area.enemies.infront", function(unit, distance)
  if not UnitExists(unit) then return 0 end
  local total = 0
  for _, Obj in pairs(NeP.OM:Get("Enemy", true)) do
    if (_G.UnitAffectingCombat(Obj.key) or Obj.isdummy)
     and NeP.Protected.Distance(unit, Obj.key) <= tonumber(distance)
     and NeP.Protected.Infront(unit, Obj.key) then
      total = total +1
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).friendly >= #
NeP.DSL:Register("area.friendly", function(unit, distance)
  if not UnitExists(unit) then return 0 end
  local total = 0
  for _, Obj in pairs(NeP.OM:Get("Friendly", true)) do
	 if NeP.Protected.Distance(unit, Obj.key) <= tonumber(distance) then
      total = total +1
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).friendly.infront >= #
NeP.DSL:Register("area.friendly.infront", function(unit, distance)
  if not UnitExists(unit) then return 0 end
  local total = 0
  for _, Obj in pairs(NeP.OM:Get("Friendly", true)) do
	if NeP.Protected.Distance(unit, Obj.key) <= tonumber(distance)
     and NeP.Protected.Infront(unit, Obj.key) then
      total = total +1
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).incdmg >= #
NeP.DSL:Register("area.incdmg", function(unit, distance)
  if not UnitExists(unit) then return 0 end
  local total = 0
  for _, Obj in pairs(NeP.OM:Get("Roster")) do
	if NeP.Protected.Distance(unit, Obj.key) <= tonumber(distance) then
      total = total + NeP.DSL:Get("incdmg")(Obj.key)
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).dead >= #
NeP.DSL:Register("area.dead", function(unit, distance)
  if not UnitExists(unit) then return 0 end
  local total = 0
  for _, Obj in pairs(NeP.OM:Get("Dead")) do
	 if NeP.Protected.Distance(unit, Obj.key) <= tonumber(distance) then
      total = total + 1
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE, HEALTH).heal >= #
NeP.DSL:Register("area.heal", function(unit, args)
	local total = 0
	if not UnitExists(unit) then return total end
	local distance, health = strsplit(",", args, 2)
	for _,Obj in pairs(NeP.OM:Get("Roster")) do
		if Obj.health <= (tonumber(health) or 100)
         and NeP.Protected.Distance(unit, Obj.key) <= (tonumber(distance) or 20) then
			total = total + 1
		end
	end
	return total
end)

-- USAGE: UNIT.area(DISTANCE, HEALTH).heal.infront >= #
NeP.DSL:Register("area.heal.infront", function(unit, args)
	local total = 0
	if not UnitExists(unit) then return total end
	local distance, health = strsplit(",", args, 2)
	for _,Obj in pairs(NeP.OM:Get("Roster")) do
		if Obj.health <= (tonumber(health) or 100)
		 and NeP.Protected.Infront(unit, Obj.key)
         and NeP.Protected.Distance(unit, Obj.key) <= (tonumber(distance) or 20) then
			total = total + 1
		end
	end
	return total
end)