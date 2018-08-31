local _, NeP = ...
local _G = _G

local talents = {}
local rows = 7
local cols = 3

local function UpdateTalents()
  -- this is always 1, dont know why bother but oh well...
  local spec = _G.GetActiveSpecGroup()
  for i = 1, rows do
    for k = 1, cols do
      local talent_ID, talent_name = _G.GetTalentInfo(i, k, spec)
      if not talent_name then return end
      talents[talent_name] = talent_ID
      talents[talent_ID] = talent_ID
      talents[tostring(i)..','..tostring(k)] = talent_ID
    end
  end
end

NeP.Listener:Add('NeP_Talents', 'PLAYER_LOGIN', function()
  UpdateTalents()
  NeP.Listener:Add('NeP_Talents', 'ACTIVE_TALENT_GROUP_CHANGED', function()
    UpdateTalents()
  end)
end)

NeP.DSL:Register("talent", function(_, args)
  return select(10, _G.GetTalentInfoByID(talents[args], _G.GetActiveSpecGroup()))
end)
