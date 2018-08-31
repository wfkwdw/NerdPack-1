local _, NeP = ...
local _G = _G
NeP.Tooltip = {}
local frame = _G.CreateFrame('GameTooltip', 'NeP_ScanningTooltip', _G.UIParent, 'GameTooltipTemplate')

local function pPattern(text, pattern)
	local pattern_tp = type(pattern)
	if pattern_tp == 'string' then
		local match = text:lower():match(pattern)
		if match then return true end
	elseif pattern_tp == 'table' then
		for i=1, #pattern do
			local match = text:lower():match(pattern[i])
			if match then return true end
		end
	end
end

function NeP.Tooltip.Scan_Buff(_, target, pattern)
	for i = 1, 40 do
		frame:SetOwner(_G.UIParent, 'ANCHOR_NONE')
		frame:SetUnitBuff(target, i)
		local tooltipText = _G["NeP_ScanningTooltipTextLeft2"]:GetText()
		if tooltipText and pPattern(tooltipText, pattern) then return true end
	end
	return false
end

function NeP.Tooltip.Scan_Debuff(_, target, pattern)
	for i = 1, 40 do
		frame:SetOwner(_G.UIParent, 'ANCHOR_NONE')
		frame:SetUnitDebuff(target, i)
		local tooltipText = _G["NeP_ScanningTooltipTextLeft2"]:GetText()
		if tooltipText and pPattern(tooltipText, pattern) then return true end
	end
	return false
end

function NeP.Tooltip.Unit(_, target, pattern)
	frame:SetOwner(_G.UIParent, 'ANCHOR_NONE')
	frame:SetUnit(target)
	local tooltipText = _G["NeP_ScanningTooltipTextLeft2"]:GetText()
	if pPattern(_G.UnitName(target):lower(), pattern) then return true end
	return tooltipText and pPattern(tooltipText, pattern)
end

function NeP.Tooltip.Tick_Time(_, target)
	frame:SetOwner(_G.UIParent, 'ANCHOR_NONE')
	frame:SetUnitBuff(target)
	local tooltipText = _G["NeP_ScanningTooltipTextLeft2"]:GetText()
	local match = tooltipText:lower():match("[0-9]+%.?[0-9]*")
	return tonumber(match)
end
