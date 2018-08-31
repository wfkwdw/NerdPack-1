--[[local Keys = {}

local bt = CreateFrame("CheckButton", 'NeP_KeyListener', UIParent)
bt:EnableKeyboard(true)
bt:EnableMouse(true)
bt:EnableMouseWheel(true)
bt:RegisterForClicks("AnyUp", "AnyDown")
bt:SetScript("OnKeyDown", function(self, key)
	local bind = GetBindingFromClick(key)
	if bind ~= "" then
		RunBinding(bind)
	end

	RunBinding(key)
	Keys[key] = true
	print(key)
end)
bt:SetScript("OnKeyUp", function(self, key)
	RunBinding(key)
	Keys[key] = false
	print(key)
end)]]