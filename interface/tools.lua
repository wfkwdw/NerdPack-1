local _, NeP = ...
NeP.Interface.usedGUIs = {}
local LibStub = _G.LibStub
local unpack = _G.unpack
local DiesalGUI = LibStub("DiesalGUI-1.0")
local element_space = 2
function NeP.Interface.Noop() end

local Elements = {
	header = 'Header',
	text = 'Text',
	rule = 'Rule',
	ruler = 'Rule',
	texture = 'Texture',
	checkbox = 'Checkbox',
	spinner = 'Spinner',
	checkspin = 'Checkspin',
	combo = 'Combo',
	dropdown = 'Combo',
	button = 'Button',
	input = 'Input',
	spacer = 'Spacer'
}

local default_profiles = {{key='default',text='Default'}}
local new_prof_Name = "New Profile Name"

local function new_prof(table, parent)
	local pFrame = NeP.Interface.pFrame
	local profileName = pFrame.Input:GetText()
	if profileName == ''
	or profileName == new_prof_Name
	or profileName == "settings" then
		return pFrame.Button:SetText('Profile cant have that name!')
	end
	for _,p in ipairs(table.av_profiles) do
		if p.key == profileName then
			return pFrame.Button:SetText('Profile with that name exists!')
		end
	end
	_G.table.insert(table.av_profiles, {key = profileName, text = profileName})
	NeP.Config:Write(table.key, 'av_profiles', table.av_profiles, 'settings')
	NeP.Config:Write(table.key, 'selected_profile', profileName, 'settings')
	pFrame:Hide()
	parent:Hide()
	parent:Release()
	NeP.Interface.usedGUIs[table.key] = nil
	NeP.Interface:BuildGUI(table)
	pFrame:Hide()
	pFrame.Input:SetText(new_prof_Name)
end

local function del_prof(table, parent)
	for i,p in ipairs(table.av_profiles) do
		if p.key == table.selected_profile then
			if table.selected_profile ~= 'default' then
				table.av_profiles[i] = nil
			end
			NeP.Config:Write(table.key, 'av_profiles', table.av_profiles, 'settings')
			NeP.Config:Write(table.key, 'selected_profile', 'default', 'settings')
			parent:Hide()
			parent:Release()
			NeP.Interface.usedGUIs[table.key] = nil
			NeP.Config:Reset(table.key, nil, table.selected_profile)
			NeP.Interface:BuildGUI(table)
			break
		end
	end
end

function NeP.Interface:BuildGUI_New(table, parent)
	local tmp = DiesalGUI:Create('Button')
	parent:AddChild(tmp)
	tmp:SetParent(parent.footer)
	tmp:SetPoint('TOPLEFT',21,0)
	tmp:SetSettings({width = 21, height = 21}, true)
	tmp:SetText('N')
	tmp:SetStylesheet(self.buttonStyleSheet)
	tmp:SetEventListener('OnClick', function()
		local pFrame = NeP.Interface.pFrame
		pFrame:Show()
		pFrame.Button:SetEventListener('OnClick', function() new_prof(table, parent) end)
	end)
end

function NeP.Interface:BuildGUI_Del(table, parent)
	local tmp = DiesalGUI:Create('Button')
	parent:AddChild(tmp)
	tmp:SetParent(parent.footer)
	tmp:SetPoint('TOPLEFT')
	tmp:SetSettings({width = 21, height = 21}, true)
	tmp:SetText('D')
	tmp:SetStylesheet(self.buttonStyleSheet)
	tmp:SetEventListener('OnClick', function() del_prof(table, parent) end)
end

function NeP.Interface:BuildGUI_Combo(table, parent)
		local tmp = DiesalGUI:Create('Dropdown')
		parent:AddChild(tmp)
		tmp:SetParent(parent.footer)
		tmp:SetPoint("TOPRIGHT", parent.footer, "TOPRIGHT", 0, 0)
		tmp:SetPoint("BOTTOMLEFT", parent.footer, "BOTTOMLEFT", 42, 0)
		--tmp:SetStylesheet(self.comboBoxStyleSheet)
		local orderdKeys = {}
		local list = {}
		-- Only when loaded
		NeP.Core:WhenInGame(function()
			for i, value in pairs(table.av_profiles) do
				orderdKeys[i] = value.key
				list[value.key] = value.text
			end
			tmp:SetList(list, orderdKeys)
			tmp:SetValue(table.selected_profile)
		end)
		tmp:SetEventListener('OnValueChanged', function(_,_, value)
			if table.selected_profile == value then return end
			NeP.Config:Write(table.key, 'selected_profile', value, 'settings')
			parent:Hide()
			parent:Release()
			self.usedGUIs[table.key] = nil
			self:BuildGUI(table)
		end)
end

function NeP.Interface:AddText(element, parent, table, element_type, tmp)
	if element.text
	and element_type ~= "Text"
	and element_type ~= "Header"
	and element_type ~= "Button" then
		tmp.text2 = self:Text(element, parent, table)
		if element_type == 'Spinner' then
			tmp:SetHeight(element.height or tmp.text2:GetStringHeight())
		end
		if element_type == 'Checkspin' then
			tmp.spin:SetHeight(element.height or tmp.text2:GetStringHeight())
		end
	end
end

function NeP.Interface:AddDesc(element, parent, table, tmp)
	if element.desc then
		element.text = element.desc
		tmp.desc = self:Text(element, parent, table)
		table.offset = table.offset - tmp.desc:GetStringHeight()
	end
end

function NeP.Interface:BuildElements(table, parent)
	table.offset = -5
	for i=1, #table.config do
		local element = table.config[i]
		local element_type = Elements[element.type:lower()]
		--build element
		element.key = element.key or "fake"
		local tmp = self[element_type](self, element, parent, table)
		self:AddText(element, parent, table, element_type, tmp)
		self:AddDesc(element, parent, table, tmp)
		table.offset = table.offset - element_space
		self.usedGUIs[table.key].elements[element.key] = tmp
	end
end

function NeP.Interface:GetElement(key, element)
	return self.usedGUIs[key].elements[element].parent
end

-- This opens a existing GUI instead of creating another
function NeP.Interface:TestCreated(table)
	local test = type(table) == 'string' and table or table.key
	if self.usedGUIs[test] then
		self.usedGUIs[test].parent:Show()
		return self.usedGUIs[test]
	end
end

local function UI_WhenInGame(table, parent)
	--Colors
	if not table.color then table.color = NeP.Color end
	if type(table.color) == 'function' then table.color = table.color() end
	-- load Location
	local left, top = unpack(NeP.Config:Read(table.key, 'Location', {500, 500}, 'settings'))
	parent.settings.left = left
	parent.settings.top = top
	parent:UpdatePosition()
	--tittle
	parent:SetTitle("|cff"..table.color..(table.title or table.key).."|r", table.subtitle)
	--profiles
	table.selected_profile = NeP.Config:Read(table.key, 'selected_profile', 'default', 'settings')
	table.av_profiles = NeP.Config:Read(table.key, 'av_profiles', default_profiles, 'settings')
	parent:ApplySettings()
end

function NeP.Interface.BuildGUI(_, table)
	local self = NeP.Interface
	--Tests
	local gui_test = self:TestCreated(table)
	if gui_test then return gui_test end
	if not table.key then return end

	-- Create a new parent
	local parent = DiesalGUI:Create('Window')
	self.usedGUIs[table.key] = {}
	self.usedGUIs[table.key].parent = parent
	self.usedGUIs[table.key].elements = {}
	parent:SetWidth(table.width or 200)
	parent:SetHeight(table.height or 300)
	parent.frame:SetClampedToScreen(true)
	--parent:SetStylesheet(self.WindowStyleSheet)

	--Save Location after dragging
	parent:SetEventListener('OnDragStop', function(_,_, l, t)
		NeP.Config:Write(table.key, 'Location', {l, t}, 'settings')
	end)

	-- Only build the body after we'r done loading configs
	NeP.Core:WhenInGame(function() UI_WhenInGame(table, parent) end, 9)

	-- Build Profiles
	if table.profiles then
		parent.settings.footer = true
		self:BuildGUI_Combo(table, parent)
		self:BuildGUI_Del(table, parent)
		self:BuildGUI_New(table, parent)
	end

	--Header
	if table.header then
		parent.settings.header = true
	end

	-- Build elements
	local window = DiesalGUI:Create('ScrollFrame')
	parent:AddChild(window)
	window:SetParent(parent.content)
	window:SetAllPoints(parent.content)
	if table.config then
		self:BuildElements(table, window)
	end
	self.usedGUIs[table.key].window = window

	parent:ApplySettings()
	return self.usedGUIs[table.key]
end

function NeP.Interface.Fetch(_, a, b, default)
	local cprofile = NeP.Config:Read(a, 'selected_profile', 'default', 'settings')
	return NeP.Config:Read(a, b, default, cprofile)
end

function NeP.Interface.Write(_, a, b, key)
	local cprofile = NeP.Config:Read(a, 'selected_profile', 'default', 'settings')
	NeP.Config:Write(a, b, key, cprofile)
end
