local _, NeP = ...
NeP.AddsID = {}
NeP.AddsID.table = {}
local T = NeP.AddsID.table

function NeP.AddsID:Add(ID)
  if type(ID) == 'table' then
		for i=1, #ID do
			self:Add(ID[i])
		end
	else
		T[ID] = true
	end
end

function NeP.AddsID.Eval(_, unit)
  if tonumber(unit) then
    return T[tonumber(unit)]
  elseif _G.UnitExists(unit) then
    unit = select(6, _G.strsplit("-", _G.UnitGUID(unit)))
    return T[tonumber(unit)]
  end
end

function NeP.AddsID.Get()
  return T
end

NeP.AddsID:Add({
	--	Shadowmoon Burial Grounds
	75966	,	-- Defiled Spirit (Shadowmoon Burial Grounds)
	76518	,	-- Ritual of Bones (Shadowmoon Burial Grounds)
	--	(BRF Oregorger
  77252	,	-- Ore Crate (BRF Oregorger)
	77665	,	-- Iron Bomber (BRF Blackhand)
	77891	,	-- Grasping Earth (BRF Kromog)
	77893	,	-- Grasping Earth (BRF Kromog)
	86752	,	-- Stone Pillars (BRF Mythic Kromog)
	78583	,	-- Dominator Turret (BRF Iron Maidens)
	78584	,	-- Dominator Turret (BRF Iron Maidens)
	79504	,	-- Ore Crate (BRF Oregorger)
	--	...
	79511	,	-- Blazing Trickster (Auchindoun Heroic)
	76220	,	-- Blazing Trickster (Auchindoun Normal)
	81638	,	-- Aqueous Globule (The Everbloom)
	86644	,	-- Ore Crate (BRF Oregorger)
	76222	,	-- Rallying Banner (UBRS Black Iron Grunt)
	76267	,	-- Solar Zealot (Skyreach)
	--	HFC
	94873	,	-- Felfire Flamebelcher (HFC)
	90432	,	-- Felfire Flamebelcher (HFC)
	95586	,	-- Felfire Demolisher (HFC)
	93851	,	-- Felfire Crusher (HFC)
	90410	,	-- Felfire Crusher (HFC)
	94840	,	-- Felfire Artillery (HFC)
	90485	,	-- Felfire Artillery (HFC)
	93435	,	-- Felfire Transporter (HFC)
	93717	,	-- Volatile Firebomb (HFC)
	188293	,	-- Reinforced Firebomb (HFC)
	94865	,	-- Grasping Hand (HFC)
	93838	,	-- Grasping Hand (HFC)
	93839	,	-- Dragging Hand (HFC)
	91368	,	-- Crushing Hand (HFC)
	94455	,	-- Blademaster Jubei'thos (HFC)
	90387	,	-- Shadowy Construct (HFC)
	90508	,	-- Gorebound Construct (HFC)
	90568	,	-- Gorebound Essence (HFC)
	94996	,	-- Fragment of the Crone (HFC)
	95656	,	-- Carrion Swarm (HFC)
	91540	,	-- Illusionary Outcast (HFC)
})
