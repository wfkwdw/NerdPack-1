local _, NeP = ...
NeP.Actions = {}

local _actions = {}
local noop = function() end

function NeP.Actions.Add(_, name, func)
  _actions[name] = func
end

function NeP.Actions.Remove(_, name)
  _actions[name] = nil
end

function NeP.Actions.Eval(_, name)
  return _actions[name] or noop
end
