local _, NeP = ...
local _G = _G

NeP.Queuer = {}
local Queue = {}

function NeP.Queuer.Add(_, spell, target)
  spell = NeP.Spells:Convert(spell)
  if not spell then return end
  Queue[spell] = {
    time = _G.GetTime(),
    target = target or _G.UnitExists('target') and 'target' or 'player'
  }
end

function NeP.Queuer.Spell(_, spell)
  local skillType = _G.GetSpellBookItemInfo(spell)
  local isUsable, notEnoughMana = _G.IsUsableSpell(spell)
  if skillType ~= 'FUTURESPELL' and isUsable and not notEnoughMana then
    local GCD = NeP.DSL:Get('gcd')()
    if _G.GetSpellCooldown(spell) <= GCD then
      return true
    end
  end
end

function NeP.Queuer:Execute()
  for spell, v in pairs(Queue) do
    if (_G.GetTime() - v.time) > 5 then
      Queue[spell] = nil
    elseif self:Spell(spell) then
      NeP.Protected.Cast(spell, v.target)
      Queue[spell] = nil
      return true
    end
  end
end
