local _, NeP = ...
local LibDispellable = _G.LibStub('LibDispellable-1.0')
local tlp = NeP.Tooltip

NeP.DSL:Register('state.purge', function(target, spell)
  spell = NeP.Core:GetSpellID(spell)
  return LibDispellable:CanDispelWith(target, spell)
end)

NeP.DSL:Register('state', function(target, arg)
  local match = NeP.Locale:TA('States', tostring(arg))
  return match and tlp:Scan_Debuff(target, match)
end)

NeP.DSL:Register('immune', function(target, arg)
  local match = NeP.Locale:TA('Immune', tostring(arg))
  return match and tlp:Scan_Buff(target, match)
end)
