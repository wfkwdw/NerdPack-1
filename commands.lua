local _, NeP = ...

NeP.Commands:Register('nep', nil, 'nep', 'nerdpack')

NeP.Commands:Add('nep', 'mastertoggle', function(rest)
	NeP.Interface:toggleToggle('MasterToggle', rest == 'on')
end)

NeP.Commands:Add('nep', 'aoe', function(rest)
	NeP.Interface:toggleToggle('AoE', rest == 'on')
end)

NeP.Commands:Add('nep', 'cooldowns', function(rest)
	NeP.Interface:toggleToggle('Cooldowns', rest == 'on')
end)

NeP.Commands:Add('nep', 'interrupts', function(rest)
	NeP.Interface:toggleToggle('Interrupts', rest == 'on')
end)

NeP.Commands:Add('nep', 'version', function() NeP.Core:Print(NeP.Version) end)
NeP.Commands:Add('nep', 'show', function() NeP.Interface.MainFrame:Show() end)
NeP.Commands:Add('nep', 'hide', function() NeP.Interface.MainFrame:Hide() end)
NeP.Commands:Add('nep', 'al', function() NeP.ActionLog.Frame:Show() end)
