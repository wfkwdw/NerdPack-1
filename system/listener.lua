local _, NeP = ...
local onEvent = _G.onEvent
local CreateFrame = _G.CreateFrame
NeP.Listener = {}
local listeners = {}

local frame = CreateFrame('Frame', 'NeP_Events')
frame:SetScript('OnEvent', function(_, event, ...)
	if not listeners[event] then return end
	for k in pairs(listeners[event]) do
		listeners[event][k](...)
	end
end)

function NeP.Listener.Add(_, name, event, callback)
	if not listeners[event] then
		frame:RegisterEvent(event)
		listeners[event] = {}
	end
	listeners[event][name] = callback
end

function NeP.Listener.Remove(_, name, event)
	if listeners[event] then
		listeners[event][name] = nil
	end
end

function NeP.Listener.Trigger(_, event, ...)
	onEvent(nil, event, ...)
end
