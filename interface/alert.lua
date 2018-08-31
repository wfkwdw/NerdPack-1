local _, NeP = ...
local CreateFrame = _G.CreateFrame
local ChatFrame1 = _G.ChatFrame1
local C_Timer = _G.C_Timer

-- create the frame
local frame = CreateFrame("Frame",nil,ChatFrame1)
frame:SetSize(ChatFrame1:GetWidth(),50)
frame:SetPoint("TOP",0,0)
frame.text = frame:CreateFontString(nil,"OVERLAY","MovieSubtitleFont")
frame.text:SetAllPoints()
frame.texture = frame:CreateTexture()
frame.texture:SetAllPoints()
frame.texture:SetColorTexture(0,0,0,.50)
frame:Hide()

local function fade(self)
  local Alpha = frame:GetAlpha()
  frame:SetAlpha(Alpha-.01)
  if Alpha<=0 then
    frame:Hide()
    self:Cancel()
  end
end

--/run NeP.Interface:Alert("Hello World")
function NeP.Interface.Alert(_, txt, time)
  time = time or 5
	frame.text:SetText(txt)
  frame:SetHeight(frame.text:GetStringHeight())
	frame:SetAlpha(1)
	frame:Show()
  C_Timer.NewTicker(time/100, fade, nil)
end
