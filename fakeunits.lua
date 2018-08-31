local _, NeP = ...
local strsplit = strsplit

-- Lowest 
NeP.FakeUnits:Add("lowest", function(num, role)
	local tempTable = {}
	for _, Obj in pairs(NeP.OM:Get("Roster")) do
		if not role or (role and Obj.role == role:upper()) then
			tempTable[#tempTable+1] = {
				key = Obj.key,
				health = Obj.health
			}
		end
	end
	table.sort( tempTable, function(a,b) return a.health < b.health end )
	return tempTable[num] and tempTable[num].key
end)

-- Lowest Predicted
NeP.FakeUnits:Add({"lowestpredicted", "lowestp"}, function(num, role)
	local tempTable = {}
	for _, Obj in pairs(NeP.OM:Get("Roster")) do
		if not role or (role and Obj.role == role:upper()) then
			tempTable[#tempTable+1] = {
				key = Obj.key,
				health = Obj.predicted
			}
		end
	end
	table.sort( tempTable, function(a,b) return a.health < b.health end )
	return tempTable[num] and tempTable[num].key
end)

-- Lowest with certain buff
NeP.FakeUnits:Add({"lowestbuff", "lbuff"}, function(num, args)
	if not type(args)=='string' then
		print("lowestbuff: incorrect usage, args", args,'-', type(args))
		return
	end
	local buff, role = strsplit(',', args, 2)
    local tempTable = {}
    for _, Obj in pairs(NeP.OM:Get("Roster")) do
        if (not role or Obj.role == role) and NeP.DSL:Get("buff")(Obj.key, buff) then
            tempTable[#tempTable+1] = {
                key = Obj.key,
                health = Obj.health
            }
        end
    end
    table.sort( tempTable, function(a,b) return a.health < b.health end )
    return tempTable[num] and tempTable[num].key
end)

-- Lowets without certain buff
NeP.FakeUnits:Add({"lowestnotbuff", "lnbuff"}, function(num, args)
	if not type(args)=='string' then
		print("lowestnotbuff: incorrect usage, args", args,'-', type(args))
		return
	end
		local buff, role = strsplit(',', args, 2)
    local tempTable = {}
    for _, Obj in pairs(NeP.OM:Get("Roster")) do
        if (not role or Obj.role == role) and not NeP.DSL:Get("buff")(Obj.key, buff) then
            tempTable[#tempTable+1] = {
                key = Obj.key,
                health = Obj.health
            }
        end
    end
    table.sort( tempTable, function(a,b) return a.health < b.health end )
    return tempTable[num] and tempTable[num].key
end)

-- lowest with certain buff
NeP.FakeUnits:Add({"lowestdebuff", "ldebuff"}, function(num, args)
	if not type(args)=='string' then
		print("lowestdebuff: incorrect usage, args", args,'-', type(args))
		return
	end
		local buff, role = strsplit(',', args, 2)
    local tempTable = {}
    for _, Obj in pairs(NeP.OM:Get("Roster")) do
        if (not role or Obj.role == role) and NeP.DSL:Get("debuff.any")(Obj.key, buff) then
            tempTable[#tempTable+1] = {
                key = Obj.key,
                health = Obj.health
            }
        end
    end
    table.sort( tempTable, function(a,b) return a.health < b.health end )
    return tempTable[num] and tempTable[num].key
end)

-- lowets without certain buff
NeP.FakeUnits:Add({"lowestnotdebuff", "lndebuff"}, function(num, args)
	if not type(args)=='string' then
		print("lowestnotdebuff: incorrect usage, args", args,'-', type(args))
		return
	end
		local buff, role = strsplit(',', args, 2)
    local tempTable = {}
    for _, Obj in pairs(NeP.OM:Get("Roster")) do
        if (not role or Obj.role == role) and not NeP.DSL:Get("debuff.any")(Obj.key, buff) then
            tempTable[#tempTable+1] = {
                key = Obj.key,
                health = Obj.health
            }
        end
    end
    table.sort( tempTable, function(a,b) return a.health < b.health end )
    return tempTable[num] and tempTable[num].key
end)


local Roles = {
	["TANK"] = 1.2,
	["HEALER"] = 1,
	["DAMAGER"] = 1,
	["NONE"] = 1
}

-- Tank
NeP.FakeUnits:Add("tank", function(num)
	local tempTable = {}
	for _, Obj in pairs(NeP.OM:Get("Roster")) do
		if Obj.role == "TANK" then
			tempTable[#tempTable+1] = {
				key = Obj.key,
				prio = Obj.healthMax * Roles[Obj.role]
			}
		end
	end
	table.sort( tempTable, function(a,b) return a.prio > b.prio end )
	return tempTable[num] and tempTable[num].key
end)

-- Healer
NeP.FakeUnits:Add("healer", function(num)
	local tempTable = {}
	for _, Obj in pairs(NeP.OM:Get("Roster")) do
		if Obj.role == "HEALER" then
			tempTable[#tempTable+1] = {
				key = Obj.key,
				prio = Obj.healthMax
			}
		end
	end
	table.sort( tempTable, function(a,b) return a.prio > b.prio end )
	return tempTable[num] and tempTable[num].key
end)

-- DAMAGER
NeP.FakeUnits:Add("damager", function(num)
	local tempTable = {}
	for _, Obj in pairs(NeP.OM:Get("Roster")) do
		if Obj.role == "DAMAGER" then
			tempTable[#tempTable+1] = {
				key = Obj.key,
				prio = Obj.healthMax
			}
		end
	end
	table.sort( tempTable, function(a,b) return a.prio > b.prio end )
	return tempTable[num] and tempTable[num].key
end)

-- Lowest enemy
NeP.FakeUnits:Add({"lowestenemy", "loweste", "le"}, function(num)
	local tempTable = {}
	for _, Obj in pairs(NeP.OM:Get("Enemy")) do
		if _G.UnitExists(Obj.key) then
			tempTable[#tempTable+1] = {
				key = Obj.key,
				health = NeP.DSL:Get("health")(Obj.key)
			}
		end
	end
	table.sort( tempTable, function(a,b) return a.health < b.health end )
	return tempTable[num] and tempTable[num].key
end)

-- enemy with buff
NeP.FakeUnits:Add({"enemybuff", "ebuff"}, function(_, buff)
    for _, Obj in pairs(NeP.OM:Get("Enemy")) do
        if NeP.DSL:Get("buff")(Obj.key, buff) then
            return Obj.key
        end
    end
end)

-- enemy without buff
NeP.FakeUnits:Add({"enemynbuff", "enbuff"}, function(_, buff)
    for _, Obj in pairs(NeP.OM:Get("Enemy")) do
        if not NeP.DSL:Get("buff")(Obj.key, buff) then
            return Obj.key
        end
    end
end)

-- enemy with debuff
NeP.FakeUnits:Add({"enemydebuff", "edebuff"}, function(_, debuff)
    for _, Obj in pairs(NeP.OM:Get("Enemy")) do
        if NeP.DSL:Get("debuff")(Obj.key, debuff) then
            return Obj.key
        end
    end
end)

-- enemy without debuff
NeP.FakeUnits:Add({"enemyndebuff", "endebuff"}, function(_, debuff)
    for _, Obj in pairs(NeP.OM:Get("Enemy")) do
        if not NeP.DSL:Get("debuff")(Obj.key, debuff) then
            return Obj.key
        end
    end
end)

-- enemy ADD
NeP.FakeUnits:Add("adds", function()
    for _, Obj in pairs(NeP.OM:Get("Enemy")) do
        if NeP.AddsID:Eval(Obj.key) then
            return Obj.key
        end
    end
end)

-- enemy Boss
NeP.FakeUnits:Add("boss", function()
    for _, Obj in pairs(NeP.OM:Get("Enemy")) do
        if _G.UnitExists(Obj.key)
		and NeP.BossID:Eval(Obj.key) then
            return Obj.key
        end
    end
end)

NeP.FakeUnits:Add("enemies", function()
	return NeP.OM:Get("Enemy")
end)

NeP.FakeUnits:Add("friendly", function()
	return NeP.OM:Get("Friendly")
end)