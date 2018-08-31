local _, NeP = ...
local g = NeP.Globals

g.Actions = NeP.Actions
g.RegisterCommand = NeP.Commands.Register
g.Core = NeP.Core
g.FakeUnits = NeP.FakeUnits
g.Listener = NeP.Listener
g.Queue = NeP.Queuer.Add
g.Tooltip = NeP.Tooltip
g.Protected = NeP.Protected
g.Artifact = NeP.Artifact
g.DBM = NeP.DBM
g.ClassTable = NeP.ClassTable
g.Spells = NeP.Spells

g.CR = {
	Add = NeP.CR.Add,
	GetList = NeP.CR.GetList
}
g.Debug = {
	Add =  NeP.Debug.Add
}
g.DSL = {
	Get = NeP.DSL.Get,
	Register = NeP.DSL.Register,
	Parse = NeP.DSL.Parse
}
g.Library = {
	Add = NeP.Library.Add,
	Fetch = NeP.Library.Fetch,
	Parse = NeP.Library.Parse
}
g.OM = {
	Add = NeP.OM.Add,
	Get = NeP.OM.Get,
}
g.Interface = {
	BuildGUI = NeP.Interface.BuildGUI,
	Fetch = NeP.Interface.Fetch,
	GetElement = NeP.Interface.GetElement,
	Add = NeP.Interface.Add,
	toggleToggle = NeP.Interface.toggleToggle,
	AddToggle = NeP.Interface.AddToggle,
	Alert = NeP.Interface.Alert,
	Splash = NeP.Interface.Splash
}
g.ActionLog = {
	Add = NeP.ActionLog.Add,
}
g.AddsID = {
  Add = NeP.AddsID.Add,
  Eval = NeP.AddsID.Eval,
  Get = NeP.AddsID.Get
}
g.Debuffs = {
  Add = NeP.Debuffs.Add,
  Eval = NeP.Debuffs.Eval,
  Get = NeP.Debuffs.Get
}
g.BossID = {
  Add = NeP.BossID.Add,
  Eval = NeP.BossID.Eval,
  Get = NeP.BossID.Get
}
g.ByPassMounts = {
  Add = NeP.ByPassMounts.Add,
  Eval = NeP.ByPassMounts.Eval,
  Get = NeP.ByPassMounts.Get
}
g.Taunts = {
  Add = NeP.Taunts.Add,
  ShouldTaunt = NeP.Taunts.ShouldTaunt,
  Get = NeP.Taunts.Get
}
