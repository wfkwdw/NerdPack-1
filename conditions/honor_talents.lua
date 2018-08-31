local _, NeP = ...
local _G = _G

local honor_talents = {}
local rows = 6
local cols = 3

local function UpdateHonorTalents()
  -- this is always 1, dont know why bother but oh well...
  local spec = GetActiveSpecGroup()
  for i = 1, rows do
    for k = 1, cols do
      local talent_ID, talent_name = GetPvpTalentInfo(i, k, spec)
      if not talent_name then return end
      honor_talents[talent_name] = talent_ID
      honor_talents[talent_ID] = talent_ID
      honor_talents[tostring(i)..','..tostring(k)] = talent_ID
    end
  end
end

NeP.Listener:Add('NeP_Honor_Talents', 'PLAYER_LOGIN', function()
  UpdateHonorTalents()
	NeP.Listener:Add('NeP_Honor_Talents', 'ACTIVE_TALENT_GROUP_CHANGED', function()
    UpdateHonorTalents()
  end)
end)

NeP.DSL:Register("honortalent", function(_, args)
  return select(10, GetPvpTalentInfoByID(honor_talents[args], GetActiveSpecGroup()))
end)

NeP.DSL:Register("pvp", function(target)
  return UnitIsPVP(target, 'PLAYER')
end)
