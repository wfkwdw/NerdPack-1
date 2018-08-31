local _, NeP = ...
local DiesalGUI = LibStub("DiesalGUI-1.0")
local new_prof_Name = "New Profile Name"

NeP.Interface.pFrame = DiesalGUI:Create('Window')
local pFrame = NeP.Interface.pFrame
pFrame:SetTitle("Create Profile")
pFrame.settings.width = 200
pFrame.settings.height = 75
pFrame.settings.minWidth = pFrame.settings.width
pFrame.settings.minHeight = pFrame.settings.height
pFrame.settings.maxWidth = pFrame.settings.width
pFrame.settings.maxHeight = pFrame.settings.height
pFrame:ApplySettings()

pFrame.Input = DiesalGUI:Create('Input')
pFrame:AddChild(pFrame.Input)
pFrame.Input:SetParent(pFrame.content)
pFrame.Input:SetPoint("TOPLEFT", pFrame.content, "TOPLEFT", 5, -5)
pFrame.Input:SetPoint("BOTTOMRIGHT", pFrame.content, "TOPRIGHT", -5, -25)
pFrame.Input:SetText(new_prof_Name)

pFrame.Button = DiesalGUI:Create('Button')
pFrame:AddChild(pFrame.Button)
pFrame.Button:SetParent(pFrame.content)
pFrame.Button:SetPoint("TOPLEFT", pFrame.content, "TOPLEFT", 5, -30)
pFrame.Button:SetPoint("BOTTOMRIGHT", pFrame.content, "TOPRIGHT", -5, -50)
--pFrame.Button:SetStylesheet(NeP.Interface.buttonStyleSheet)
pFrame.Button:SetText("Create New Profile")

pFrame:Hide()
