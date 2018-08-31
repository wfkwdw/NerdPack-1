local _, NeP = ...
NeP.Taunts = {}
NeP.Taunts.table = {}
local T = NeP.Taunts.table

function NeP.Taunts:Add(id, stacks)
  if type(id) == 'table' then
    for i=1, #id do
      local tmp = id[i]
      self:Add(tmp.id, tmp.stacks)
    end
  else
    table.insert(T, {id=id, stacks=stacks})
  end
end

function NeP.Taunts:ShouldTaunt(unit)
  --Quit if we have its threat
  local threat = _G.UnitThreatSituation("player", unit) or 0
  if threat >= 3 then return end
  -- Taunts in a raid, where you have 2 tanks
  if _G.IsInRaid() then
    for i=1, #T do
      local debuff = _G.etSpellInfo(T[i].id)
      if not _G.UnitDebuff('player', debuff)
      and (select(4, _G.UnitDebuff(unit..'target', debuff)) or 0) > T[i].stacks then
        return true
      end
    end
  -- Alone stuff
  else
    return threat > 0 and threat < 3
  end
end

function NeP.Taunts:Get()
  return T
end

NeP.Taunts:Add({
  { id = 143436, stacks = 1 },-- Corrosive Blast (Immerseus/71543)
  { id = 146124, stacks = 3 },-- Self Doubt (Norushen/72276)
  { id = 144358, stacks = 1 },-- Wounded Pride (Sha of Pride/71734)
  { id = 147029, stacks = 3 },-- Flames of Galakrond (Galakras/72249)
  { id = 144467, stacks = 2 },-- Ignite Armor (Iron Juggernaut/71466)
  { id = 144215, stacks = 6 },-- Froststorm Strike (Earthbreaker Haromm) (Kor'Kron Dark Shaman/71859)
  { id = 143494, stacks = 3 },-- Sundering Blow (General Nazgrim/71515)
  { id = 142990, stacks = 12 },-- Fatal Strike (Malkorok/71454)
  { id = 143426, stacks = 2 },-- Fearsome Roar (Thok the Bloodthirsty/71529)
  { id = 143780, stacks = 2 },-- Acid Breath (Thok (Saurok eaten))
  { id = 143773, stacks = 3 },-- Freezing Breath (Thok (Jinyu eaten))
  { id = 143767, stacks = 2 },-- Scorching Breath (Thok (Yaungol eaten))
  { id = 145183, stacks = 3 } -- Gripping Despair (Garrosh/71865)
})
