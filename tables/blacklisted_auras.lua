local _, NeP = ...
NeP.Debuffs = {}
NeP.Debuffs.table = {}
local T = NeP.Debuffs.table

--[[
	DESC: Checks if unit has a Blacklisted Debuff.
	This will remove the unit from the OM cache.
---------------------------------------------------]]

function NeP.Debuffs:Eval(unit)
	for i = 1, 40 do
		local ID = select(11, _G.UnitDebuff(unit, i))
		if ID and T[ID] then
			return true
		end
	end
end

function NeP.Debuffs:Add(ID)
	if type(ID) == 'table' then
		for i=1, #ID do
			self:Add(ID[i])
		end
	else
		T[ID] = true
	end
end

function NeP.Debuffs:Get()
	return T
end

NeP.Debuffs:Add({
		-- CROWD CONTROL
	--[[118,     -- Polymorph
	1513,     -- Scare Beast
	1776,     -- Gouge
	2637,     -- Hibernate
	3355,     -- Freezing Trap
	--6770,     -- Sap
	9484,     -- Shackle Undead
	19386,     -- Wyvern Sting
	20066,     -- Repentance
	28271,     -- Polymorph (turtle)
	28272,     -- Polymorph (pig)
	49203,     -- Hungering Cold
	51514,     -- Hex
	61305,     -- Polymorph (black cat)
	61721,     -- Polymorph (rabbit)
	61780,     -- Polymorph (turkey)
	76780,     -- Bind Elemental
	82676,     -- Ring of Frost
	90337,     -- Bad Manner (Monkey) -- FIXME: to check
	115078,     -- Paralysis
	115268,     -- Mesmerize
		-- MOP DUNGEONS/RAIDS/ELITES
	106062,     -- Water Bubble (Wise Mari)
	110945,     -- Charging Soul (Gu Cloudstrike)
	116994,     -- Unstable Energy (Elegon)
	122540,     -- Amber Carapace (Amber Monstrosity - Heat of Fear)
	123250,     -- Protect (Lei Shi)
	143574,     -- Swelling Corruption (Immerseus)
	143593,     -- Defensive Stance (General Nazgrim)
		-- WOD DUNGEONS/RAIDS/ELITES
	155176,     -- Damage Shield (Primal Elementalists - Blast Furnace)
	155185,     -- Cotainment (Primal Elementalists - BRF)
	155233,     -- Dormant (Blast Furnace)
	155265,     -- Cotainment (Primal Elementalists - BRF)
	155266,     -- Cotainment (Primal Elementalists - BRF)
	155267,     -- Cotainment (Primal Elementalists - BRF)
	157289,     -- Arcane Protection (Imperator Mar'Gok)
	174057,     -- Arcane Protection (Imperator Mar'Gok)
	182055,     -- Full Charge (Iron Reaver)
	184053,     -- Fel Barrier (Socrethar)]]
})
