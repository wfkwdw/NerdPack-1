local _, NeP = ...

NeP.DSL:Register("isself", function(target)
  return NeP.DSL:Get("is")(target, 'player')
end)

NeP.DSL:Register('furydiff', function(target)
  return NeP.DSL:Get("fury.diff")(target)
end)

NeP.DSL:Register('pull_timer', function()
  return NeP.DSL:Get('dbm')(nil, "Pull in")
end)
