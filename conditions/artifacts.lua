local _, NeP = ...
local LAD = _G.LibStub("LibArtifactData-1.0")
--[[
					ARTIFACT CONDITIONS!
			Only submit ARTIFACT specific conditions here.
					KEEP ORGANIZED AND CLEAN!

--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
]]
NeP.Artifact = {}

function NeP.Artifact.Update()
    LAD.ForceUpdate()
end

function NeP.Artifact.Traits(_, artifactID)
    artifactID = LAD.GetArtifactTraits(artifactID)
    return LAD.GetArtifactTraits(artifactID)
end

function NeP.Artifact:TraitInfo(spell)
  local artifactID = NeP.DSL:Get('artifact.active_id')()
  if not artifactID then self:Update() end
  local _, traits = self:Traits(artifactID)
  if not traits then return end
  for _,v in ipairs(traits) do
    if v.name == spell then
      return v.isGold,v.bonusRanks,v.maxRank,v.traitID,v.isStart,v.icon,v.isFinal,v.name,v.currentRank,v.spellID
    end
  end
end

NeP.DSL:Register('artifact.acquired_power', function(artifactID)
  return LAD.GetAcquiredArtifactPower(artifactID)
end)

NeP.DSL:Register('artifact.active_id', function()
  return LAD.GetActiveArtifactID()
end)

NeP.DSL:Register('artifact.knowledge', function()
  return select(1,LAD.GetArtifactKnowledge())
end)

NeP.DSL:Register('artifact.power', function(artifactID)
  return select(3,LAD.GetArtifactPower(artifactID))
end)

NeP.DSL:Register('artifact.relics', function(artifactID)
  return LAD.GetArtifactRelics(artifactID)
end)

NeP.DSL:Register('artifact.num_obtained', function()
  return LAD.GetNumObtainedArtifacts()
end)

NeP.DSL:Register('artifact.enabled', function(_, spell)
    return not not select(10,NeP.Artifact:TraitInfo(spell))
end)
