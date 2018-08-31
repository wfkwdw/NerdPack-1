local _, NeP = ...
local LibStub = LibStub
local DiesalGUI   = LibStub("DiesalGUI-1.0")
local SharedMedia = LibStub("LibSharedMedia-3.0")
local UIParent = UIParent
local Type = Type
local CreateFrame = CreateFrame

DiesalGUI:RegisterObjectConstructor("FontString", function()
  local slf 		= DiesalGUI:CreateObjectBase(Type)
  local frame		= CreateFrame('Frame',nil,UIParent)
  local fontString = frame:CreateFontString(nil, "OVERLAY", 'DiesalFontNormal')
  slf.frame		= frame
  slf.fontString = fontString
  slf.SetParent = function(self, parent)
    self.frame:SetParent(parent)
  end
  slf.OnRelease = function(self)
    self.fontString:SetText('')
  end
  slf.OnAcquire = function(self)
    self:Show()
  end
  slf.type = "FontString"
  return slf
end, 1)

DiesalGUI:RegisterObjectConstructor("Rule", function()
  local slf 		= DiesalGUI:CreateObjectBase(Type)
  local frame		= CreateFrame('Frame',nil,UIParent)
  slf.frame		= frame
  frame:SetHeight(1)
  frame.texture = frame:CreateTexture()
  frame.texture:SetColorTexture(255,255,255,1)
  frame.texture:SetAllPoints(frame)
  slf.SetParent = function(self, parent)
    self.frame:SetParent(parent)
  end
  slf.OnRelease = function(self)
    self:Hide()
  end
  slf.OnAcquire = function(self)
    self:Show()
  end
  slf.type = "Rule"
  return slf
end, 1)

DiesalGUI:RegisterObjectConstructor("StatusBar", function()
  local slf  = DiesalGUI:CreateObjectBase(Type)
  local frame = CreateFrame('StatusBar',nil,UIParent)
  slf.frame  = frame

  slf:SetStylesheet(NeP.Interface.statusBarStylesheet)

  frame.Left = frame:CreateFontString()
  frame.Left:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 14)
  frame.Left:SetShadowColor(0,0,0, 0)
  frame.Left:SetShadowOffset(-1,-1)
  frame.Left:SetPoint("LEFT", frame)

  frame.Right = frame:CreateFontString()
  frame.Right:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 14)
  frame.Right:SetShadowColor(0,0,0, 0)
  frame.Right:SetShadowOffset(-1,-1)

  frame:SetStatusBarTexture(1,1,1,0.8)
  frame:GetStatusBarTexture():SetHorizTile(false)
  frame:SetMinMaxValues(0, 100)
  frame:SetHeight(16)

  slf.SetValue = function(self, value) self.frame:SetValue(value) end
  slf.SetParent = function(self, parent)
    self.parent = parent
    self.frame:SetParent(parent)
    self.frame:SetPoint("LEFT", parent, "LEFT")
    self.frame:SetPoint("RIGHT", parent, "RIGHT")
    self.frame.Right:SetPoint("RIGHT", self.frame, "RIGHT", -2, 2)
    self.frame.Left:SetPoint("LEFT", self.frame, "LEFT", 2, 2)
  end
  slf.OnRelease = function(self) self:Hide() end
  slf.OnAcquire = function(self) self:Show() end
  slf.type = "StatusBar"
  return slf
end, 1)
