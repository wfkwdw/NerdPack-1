local _, NeP = ...
local _G = _G
local UIParent = _G.UIParent
local CreateFrame = _G.CreateFrame
local C_Timer = _G.C_Timer
local PlaySound = _G.PlaySound
local GetSpecialization = _G.GetSpecialization
local GetSpecializationInfo = _G.GetSpecializationInfo

-- Splash stuff
local frame = CreateFrame("Frame", "Zylla_SPLASH", UIParent)
frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 }
});
frame:SetBackdropColor(0,0,0,1);
frame.texture = frame:CreateTexture()
frame.texture:SetPoint("LEFT",-4,0)
frame.texture:SetSize(100,100)
frame.text = frame:CreateFontString(nil, "BACKGROUND", "MovieSubtitleFont");
frame.text:SetPoint("RIGHT",-4,0)
frame:Hide()

local function Ticker(self)
  local Alpha = frame:GetAlpha()
  frame:SetAlpha(Alpha-.01)
  if Alpha<=0 then
    frame:Hide()
    self:Cancel()
  end
end

local function SpecIcon()
  local currentSpec = GetSpecialization()
  return select(4,GetSpecializationInfo(currentSpec))
end

--/run NeP.Interface:Splash("Hello World")
function NeP.Interface.Splash(_, txt, icon, time)
  icon = icon or SpecIcon()
  time = time or 5
	frame:SetAlpha(1)
	frame:Show()
	PlaySound(124, "SFX");
	frame.texture:SetTexture(icon)
	frame.text:SetText(txt)
	local Width = frame.text:GetStringWidth()+frame.texture:GetWidth()+8
	frame:SetSize(Width,100)
	frame:SetPoint("CENTER",0,335	)
  C_Timer.NewTicker(time/100, Ticker, nil)
end
