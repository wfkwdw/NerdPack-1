local _, NeP = ...
local _G = _G

NeP.DSL:Register({'equipped', 'item'}, function(_, item)
  return _G.IsEquippedItem(item)
end)

NeP.DSL:Register('item.cooldown', function(_, item)
	local start, duration = _G.GetItemCooldown(item)
	if not start then return 0 end
  return start ~= 0 and (start + duration - _G.GetTime()) or 0
end)

NeP.DSL:Register('item.usable', function(_, item)
	local isUsable, notEnoughMana = _G.IsUsableItem(item)
  if not isUsable or notEnoughMana or NeP.DSL:Get('item.cooldown')(nil, item) ~= 0 then return false end
	return true
end)

NeP.DSL:Register('item.count', function(_, item)
  return _G.GetItemCount(item, false, true)
end)

NeP.DSL:Register('twohand', function()
  return _G.IsEquippedItemType("Two-Hand")
end)

NeP.DSL:Register('onehand', function()
  return _G.IsEquippedItemType("One-Hand")
end)

NeP.DSL:Register("ilevel", function()
  return math.floor(select(1,_G.GetAverageItemLevel()))
end)
