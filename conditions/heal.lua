local _, NeP = ...

local function GetPredictedHealth(unit)
	return UnitHealth(unit)+(UnitGetIncomingHeals(unit) or 0)
end

local function GetPredictedHealth_Percent(unit)
	return math.floor((GetPredictedHealth(unit)/UnitHealthMax(unit))*100)
end

local function healthPercent(unit)
	return math.floor((UnitHealth(unit)/UnitHealthMax(unit))*100)
end

NeP.DSL:Register("health", function(target)
	return healthPercent(target)
end)

NeP.DSL:Register("health.actual", function(target)
	return UnitHealth(target)
end)

NeP.DSL:Register("health.max", function(target)
	return UnitHealthMax(target)
end)

NeP.DSL:Register("health.predicted", function(target)
	return GetPredictedHealth_Percent(target)
end)

NeP.DSL:Register("health.predicted.actual", function(target)
	return GetPredictedHealth(target)
end)