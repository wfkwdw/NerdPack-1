local _, NeP = ...
NeP.CR = {}
NeP.CR.CR = {}
local CRs = {}
local noop = function() end

function NeP.CR.AddGUI(_, ev)
	local gui_st = ev.gui_st or {}
	local temp = {
		title = gui_st.title or ev.name,
		key = ev.name,
		width = gui_st.width or 200,
		height = gui_st.height or 300,
		config = ev.gui,
		color = gui_st.color,
		profiles = true
	}
	ev.gui = true
	NeP.Interface:BuildGUI(temp).parent:Hide()
end

local function legacy_PE(...)
	local ev, InCombat, OutCombat, ExeOnLoad, GUI = ...
	if type(...) == 'string' then
		return {
			name = ev,
			ic = InCombat,
			ooc = OutCombat,
			load = ExeOnLoad,
			gui = GUI
		}
	else
		return ...
	end
end

local function add(ev)
	local cr = {}
	cr.name = ev.name
	cr.spec = ev.id
	cr.load = ev.load
	cr.unload = ev.unload
	cr[true] = ev.ic
	cr[false] = ev.ooc
	cr.wow_ver = ev.wow_ver
	cr.nep_ver = ev.nep_ver
	cr.blacklist = ev.blacklist
	cr.has_gui = ev.gui
	cr.blacklist.units = ev.blacklist.units or {}
	cr.blacklist.buff = ev.blacklist.buff or {}
	cr.blacklist.debuff = ev.blacklist.debuff or {}
	CRs[ev.id] = CRs[ev.id] or {}
	CRs[ev.id][ev.name] = cr
end

local function refs(ev, SpecID)
	ev.id = SpecID
	ev.ic = ev.ic or {}
	ev.ooc = ev.ooc or {}
	ev.wow_ver = ev.wow_ver or 0.00
	ev.nep_ver = ev.nep_ver or 0.00
	ev.load = ev.load or noop
	ev.unload = ev.unload or noop
	ev.blacklist = ev.blacklist or {}
	ev.blacklist.units = ev.blacklist.units or {}
	ev.blacklist.buff = ev.blacklist.buff or {}
	ev.blacklist.debuff = ev.blacklist.debuff or {}
end

function NeP.CR.Add(_, SpecID, ...)
	local classIndex = select(3, UnitClass('player'))
	-- This only allows crs we can use to be registered
	if not NeP.ClassTable:SpecIsFromClass(classIndex, SpecID )
	and classIndex ~= SpecID then
		return
	end
	-- Legacy stuff
	local ev = legacy_PE(...)
	--refs
	refs(ev, SpecID)
	-- Import SpellIDs from the cr
	if ev.ids then NeP.Spells:Add(ev.ids) end
	-- This compiles the CR
	local master_cr = { name = ev.name, pooling = ev.pooling }
	ev.ic.master = master_cr
	ev.ooc.master = master_cr
	NeP.Compiler:Iterate(ev.ic)
	NeP.Compiler:Iterate(ev.ooc)
	--Create user GUI
	if ev.gui then NeP.CR:AddGUI(ev) end
	-- Class Cr (gets added to all specs whitin that class)
	if classIndex == SpecID then
		SpecID = NeP.ClassTable:GetClassSpecs(classIndex)
		for i=1, #SpecID do
			ev.id = SpecID[i]
			add(ev)
		end
		return
	end
	-- normal add
	add(ev)
end

function NeP.CR:Set(Spec, Name)
	Spec = Spec or GetSpecializationInfo(GetSpecialization())
	Name = Name or NeP.Config:Read('SELECTED', Spec)
	--break if no sec or name
	if not Spec or not Name then return end
	--break if cr dosent exist
	if not (CRs[Spec] and CRs[Spec][Name]) then return end
	-- execute the previous unload
	if self.CR and self.CR.unload then self.CR.unload() end
	self.CR = CRs[Spec][Name]
	NeP.Config:Write('SELECTED', Spec, Name)
	NeP.Interface:ResetToggles()
	--Execute onload
	if self.CR then self.CR.load() end
end

function NeP.CR.GetList(_, Spec)
	return CRs[Spec] or {}
end

----------------------------EVENTS
NeP.Listener:Add("NeP_CR", "PLAYER_LOGIN", function()
	NeP.CR:Set()
end)
NeP.Listener:Add("NeP_CR", "PLAYER_SPECIALIZATION_CHANGED", function(unitID)
	if unitID ~= 'player' then return end
	NeP.CR:Set()
end)
