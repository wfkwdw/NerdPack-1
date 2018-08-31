local _, NeP = ...

NeP.Buttons = {}

local nBars = {
	"ActionButton",
	"MultiBarBottomRightButton",
	"MultiBarBottomLeftButton",
	"MultiBarRightButton",
	"MultiBarLeftButton"
}

local function UpdateButtons()
	_G.wipe(NeP.Buttons)
	for _, group in ipairs(nBars) do
		for i =1, 12 do
			local button = _G[group .. i]
			if button then
				local actionType, id = _G.GetActionInfo(_G.ActionButton_CalculateAction(button, "LeftButton"))
				if actionType == 'spell' then
					local spell = _G.GetSpellInfo(id)
					if spell then
						NeP.Buttons[spell] = button
					end
				end
			end
		end
	end
end

NeP.Listener:Add('NeP_Buttons','PLAYER_ENTERING_WORLD', function ()
	UpdateButtons()
end)

NeP.Listener:Add('NeP_Buttons','ACTIONBAR_SLOT_CHANGED', function ()
	UpdateButtons()
end)
