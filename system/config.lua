local n_name, NeP = ...

NeP.Config = {}
local Data = {}
local version = "0.2"

NeP.Listener:Add("NeP_Config", "ADDON_LOADED", function(addon)
	if addon:lower() == n_name:lower() then
		_G.NePDATA = _G.NePDATA or Data
		Data = _G.NePDATA
		if Data["config_ver"] ~= version then _G.wipe(Data) end
		Data["config_ver"] = version
	end
end)

function NeP.Config.Read(_, a, b, default, profile)
	profile = profile or "default"
	if Data[a] then
		if not Data[a][profile] then
			Data[a][profile] = {}
		end
		if Data[a][profile][b] == nil then
			Data[a][profile][b] = default
		end
	else
		Data[a] = {}
		Data[a][profile] = {}
		Data[a][profile][b] = default
	end
	return Data[a][profile][b]
end

function NeP.Config.Write(_, a, b, value, profile)
	profile = profile or "default"
	if not Data[a] then Data[a] = {} end
	if not Data[a][profile] then Data[a][profile] = {} end
	Data[a][profile][b] = value
end

function NeP.Config.Reset(_, a, b, profile)
	if profile then
		Data[a][profile] = nil
	elseif b then
		if Data[a][profile] then
			Data[a][profile][b] = nil
		end
	elseif a then
		Data[a] = nil
	end
end

function NeP.Config.Rest_all()
	_G.wipe(Data)
end
