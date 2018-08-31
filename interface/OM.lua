local _, NeP = ...
local DiesalGUI = LibStub('DiesalGUI-1.0')
local L = NeP.Locale

local statusBars = {}
local statusBarsUsed = {}
local dOM = 'Enemy'

local bt = {
	{key = 'Enemy', text = 'Enemies'},
	{key = 'Friendly', text = 'Friendlies'},
	{key = 'Dead', text = 'Dead Units'},
	{key = 'Objects', text = 'Objects'},
	{key = 'Roster', text = 'Roster'},
}
local combo_eval = {key = "list", list = bt, default = "Enemy"}
local gui_eval = {key = 'NePOMgui', width = 500, height = 250, header = true, title = 'ObjectManager GUI'}

local OM_GUI = NeP.Interface:BuildGUI(gui_eval)
NeP.Interface:Add(L:TA('OM', 'Option'), function() OM_GUI.parent:Show() end)
local dropdown = NeP.Interface:Combo(combo_eval, OM_GUI.parent, {key="OM_GUI", offset = 0})
dropdown:SetPoint("TOPRIGHT", OM_GUI.parent.header, "TOPRIGHT", 0, 0)
dropdown:SetPoint("BOTTOMLEFT", OM_GUI.parent.header, "BOTTOMLEFT", (gui_eval.width-100), 0)
dropdown:SetEventListener('OnValueChanged', function(_,_, value) dOM = value end)
OM_GUI.parent:Hide()

local function getStatusBar()
	local statusBar = tremove(statusBars)
	if not statusBar then
		statusBar = DiesalGUI:Create('StatusBar')
		OM_GUI.window:AddChild(statusBar)
		statusBar:SetParent(OM_GUI.window.content)
		OM_GUI.parent:AddChild(statusBar)
		statusBar.frame:SetStatusBarColor(1,1,1,0.35)
	end
	statusBar:Show()
	table.insert(statusBarsUsed, statusBar)
	return statusBar
end

local function recycleStatusBars()
	for i = #statusBarsUsed, 1, -1 do
		statusBarsUsed[i]:Hide()
		tinsert(statusBars, tremove(statusBarsUsed))
	end
end

local function GetTable()
	local tmp = {}
	for _, Obj in pairs(NeP.OM:Get(dOM, true)) do
		tmp[#tmp+1] = Obj
	end
	table.sort( tmp, function(a,b) return a.distance < b.distance end )
	return tmp
end

local function RefreshGUI()
	local offset = -5
	recycleStatusBars()
	for _, Obj in pairs(GetTable()) do
		local Health = math.floor(((UnitHealth(Obj.key) or 1) / (UnitHealthMax(Obj.key) or 1)) * 100)
		local SB = getStatusBar()
		local distance = NeP.Core:Round(Obj.distance or 0)
		SB.frame:SetPoint('TOP', OM_GUI.window.content, 'TOP', 2, offset )
		SB.frame.Left:SetText('|cff'..NeP.Core:ClassColor(Obj.key, 'hex')..Obj.name)
		SB.frame.Right:SetText('( |cffff0000ID|r: '..Obj.id..' / |cffff0000Health|r: '..Health..' / |cffff0000Dist|r: '..distance..' )')
		SB.frame:SetScript('OnMouseDown', function() TargetUnit(Obj.key) end)
		SB:SetValue(Health)
		offset = offset -18
	end
end

C_Timer.NewTicker(0.1, (function()
	if OM_GUI.parent:IsShown() then
		RefreshGUI()
	end
end), nil)
