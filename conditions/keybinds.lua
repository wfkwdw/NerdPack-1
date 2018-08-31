local _, NeP = ...
local _G = _G

local KEYBINDS = {
  -- Shift
  ['shift']    = function() return _G.IsShiftKeyDown() end,
  ['lshift']   = function() return _G.IsLeftShiftKeyDown() end,
  ['rshift']   = function() return _G.IsRightShiftKeyDown() end,
  -- Control
  ['control']  = function() return _G.IsControlKeyDown() end,
  ['lcontrol'] = function() return _G.IsLeftControlKeyDown() end,
  ['rcontrol'] = function() return _G.IsRightControlKeyDown() end,
  -- Alt
  ['alt']      = function() return _G.IsAltKeyDown() end,
  ['lalt']     = function() return _G.IsLeftAltKeyDown() end,
  ['ralt']     = function() return _G.IsRightAltKeyDown() end,
}

NeP.DSL:Register("keybind", function(_, Arg)
  Arg = Arg:lower()
  return KEYBINDS[Arg] and KEYBINDS[Arg]() and not _G.GetCurrentKeyBoardFocus()
end)

NeP.DSL:Register("mouse", function(_, Arg)
  Arg = tonumber(Arg:lower())
  return _G.IsMouseButtonDown(Arg) and not _G.GetCurrentKeyBoardFocus()
end)
