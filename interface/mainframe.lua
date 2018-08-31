local n_name, NeP = ...
local logo = '|T'..NeP.Media..'logo.blp:10:10|t'
local L = NeP.Locale
local NeP_ver = tostring(NeP.Version.major.."."..NeP.Version.minor.."-"..NeP.Version.branch)

local EasyMenu = _G.EasyMenu
local CreateFrame = _G.CreateFrame
local GetSpecializationInfo = _G.GetSpecializationInfo
local GetSpecialization = _G.GetSpecialization
local GetBuildInfo = _G.GetBuildInfo

local function CR_Ver_WoW(cr_wow_ver, wow_ver)
	return wow_ver:find('^'..tostring(cr_wow_ver))
end

local function CR_Ver_NeP(cr_nep_ver, NeP_ver)
	return NeP_ver:find('^'..tostring(cr_nep_ver))
end

NeP.Interface.MainFrame = NeP.Interface:BuildGUI({
	key = 'NePMFrame',
	width = 100,
	height = 60,
	title = logo..n_name,
	subtitle = 'v:'..NeP_ver
}).parent
NeP.Interface.MainFrame:SetEventListener('OnClose', function()
	NeP.Core:Print(L:TA('Any', 'NeP_Show'))
end)

local menuFrame = CreateFrame("Frame", 'NeP_DropDown', NeP.Interface.MainFrame.frame, "UIDropDownMenuTemplate")
menuFrame:SetPoint("BOTTOMLEFT", NeP.Interface.MainFrame.frame, "BOTTOMLEFT", 0, 0)
menuFrame:Hide()

local DropMenu = {
	{text = logo..'['..n_name..' |rv:'..NeP_ver..']', isTitle = 1, notCheckable = 1},
	{text = L:TA('mainframe', 'CRS'), hasArrow = true, menuList = {}},
	{text = L:TA('mainframe', 'CRS_ST'), hasArrow = true, menuList = {}}
}

function NeP.Interface.ResetCRs()
	DropMenu[2].menuList = {}
	DropMenu[3].menuList = {}
	local spec = GetSpecializationInfo(GetSpecialization())
	for _,v in pairs(NeP.CR:GetList(spec)) do
		NeP.Interface:AddCR(v)
		if v.has_gui then NeP.Interface:AddCR_ST(v.name) end
	end
end

function NeP.Interface.UpdateCRs()
	local spec = GetSpecializationInfo(GetSpecialization())
	local last = NeP.Config:Read('SELECTED', spec)
	for _,v in pairs(DropMenu[2].menuList) do
		v.checked = last == v.name
	end
end

function NeP.Interface:AddCR_ST(Name)
	table.insert(DropMenu[3].menuList, {
		text = Name,
		notCheckable = 1,
		func = function()
			self:BuildGUI(Name)
		end
	})
end

function NeP.Interface.AddCR(_, ev)
	local text = ev.name..'|cff0F0F0F <->|r [WoW: '..ev.wow_ver..' NeP: '..ev.nep_ver..']'
	local NeP_ver = NeP_ver
	local wow_ver = GetBuildInfo()
	table.insert(DropMenu[2].menuList, {
		text = text,
		name = ev.name,
		func = function()
			NeP.CR:Set(ev.spec, ev.name)
				if not CR_Ver_WoW(ev.wow_ver, wow_ver)  then
					NeP.Core:Print(ev.name, "|rwas not built for WoW:", wow_ver, "\nThis might cause problems!")
				end
				if not CR_Ver_NeP(ev.nep_ver, NeP_ver) then
					NeP.Core:Print(ev.name, "|rwas not built for", NeP_ver, "\nThis might cause problems!")
				end
				NeP.Core:Print(L:TA('mainframe', 'ChangeCR'), ev.name)
				NeP.Interface.UpdateCRs()
		end
	})
end

function NeP.Interface.DropMenu()
	EasyMenu(DropMenu, menuFrame, menuFrame, 0, 0, "MENU")
end

function NeP.Interface.Add(_, name, func)
	table.insert(DropMenu, {
		text = tostring(name),
		func = func,
		notCheckable = 1
	})
end

----------------------------EVENTS
NeP.Listener:Add("NeP_CR_interface", "PLAYER_LOGIN", function()
	NeP.Interface.ResetCRs()
end)
NeP.Listener:Add("NeP_CR_interface", "PLAYER_SPECIALIZATION_CHANGED", function(unitID)
	if unitID ~= 'player' then return end
	NeP.Interface:ResetCRs()
end)
