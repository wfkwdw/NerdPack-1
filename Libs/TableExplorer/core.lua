-- $Id: TableExplorer.lua 16 2014-02-24 05:55:58Z diesal2010 $
local AddOnName, Env = ...
local ADDON = {}
Env[1], _G[AddOnName] = ADDON, ADDON

-- ~~| Lua Upvalues |~~~~~~~~~~~~~~~
local DiesalGUI 		= LibStub("DiesalGUI-1.0")
local print, type, tostring, tonumber	= print, type, tostring, tonumber

-- ~~| Slash Command |~~~~~~~~~~~~~~~
SLASH_TEXPLORE1= '/texplore'
function SlashCmdList.TEXPLORE(msg)
 local table, depth = msg:match("^([^%s]*)%s*(%d*).*$")
	if not _G[table] then print('table dosnt exist') return end
	texplore(table,_G[table],tonumber(depth))
end

-- | Global Explorer Call |~~~~~~~~~~~~~~~
function texplore(tname,t,depth)
	local explorer = DiesalGUI:Create('TableExplorer')
	t = type(tname) == 'table' and tname or t
	tname = type(tname) == 'table' and tostring(tname) or tname
	depth = type(t) == 'number' and t or depth

	explorer:SetTable(tname,t,depth)
end
