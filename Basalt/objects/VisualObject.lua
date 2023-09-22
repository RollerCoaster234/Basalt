local Object = require("objectLoader").load("Object")
local split = require("utils").splitString

local VisualObject = setmetatable({}, Object)

local function BaseRender(self)
  local w, h = self:getSize()
  self:addTextBox(1, 1, w, h, " ")
  self:addBackgroundBox(1, 1, w, h, self:getBackground())
  self:addForegroundBox(1, 1, w, h, self:getForeground())
end

Object:initialize("VisualObject")
Object:addProperty("background", "color", colors.black)
Object:addProperty("foreground", "color", colors.white)
Object:addProperty("x", "number", 1)
Object:addProperty("y", "number", 1)
Object:combineProperty("Position", "X", "Y")
Object:addProperty("visible", "boolean", true)
Object:addProperty("width", "number", 1)
Object:addProperty("height", "number", 1)
Object:addProperty("renderData", "table", {BaseRender}, false, function(self, value)
  if(type(value)=="function")then
    table.insert(self.renderData, value)
    return self.renderData
  end
end)

Object:combineProperty("Size", "width", "height")
Object:addProperty("transparent", "boolean", false)
Object:addProperty("ignoreOffset", "boolean", false)
Object:addProperty("focused", "boolean", false, nil, function(self, value)
  if(value)then
    self:get_focus()
  else
    self:lose_focus()
  end
end)

Object:addListener("click", "mouse_click")
Object:addListener("drag", "mouse_drag")
Object:addListener("scroll", "mouse_scroll")
Object:addListener("hover", "mouse_move")
Object:addListener("leave", "mouse_move2")
Object:addListener("clickUp", "mouse_up")
Object:addListener("key", "key")
Object:addListener("keyUp", "key_up")
Object:addListener("char", "char")
Object:addListener("getFocus", "get_focus")
Object:addListener("loseFocus", "lose_focus")

function VisualObject:new(id, basalt)
  local newInstance = Object:new(id, basalt)
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:create("VisualObject")
  newInstance:setType("VisualObject")
  return newInstance
end

function VisualObject.render(self)
    for _,v in pairs(self.renderData)do
      v(self)
    end
end

for _,v in pairs({"BackgroundBox", "TextBox", "ForegroundBox"})do
  VisualObject["add"..v] = function(self, x, y, w, h, col)
    local obj = self.parent or self
    local xPos,yPos = self:getPosition()
    if(self.parent~=nil)then
        local xO, yO = self.parent:getOffset()
        local ignOffset = self:getIgnoreOffset()
        xPos = ignOffset and xPos or xPos - xO
        yPos = ignOffset and yPos or yPos - yO
    end
    obj["draw"..v](obj, x+xPos-1, y+yPos-1, w, h, col)
  end
end

function VisualObject.blit(self, x, y, t, fg, bg)
  local obj = self.parent or self
  local xPos,yPos = self:getPosition()
  local transparent = self:getTransparent()
  if(self.parent~=nil)then
      local xO, yO = self.parent:getOffset()
      local ignOffset = self:getIgnoreOffset()
      xPos = ignOffset and xPos or xPos - xO
      yPos = ignOffset and yPos or yPos - yO
  end
  if not(transparent)then
      obj:blit(x+xPos-1, y+yPos-1, t, fg, bg)
      return
  end
  local _text = split(t, "\0")
  local _fg = split(fg)
  local _bg = split(bg)
  for _,v in pairs(_text)do
      if(v.value~="")or(v.value~="\0")then
          obj:setText(x+v.x+xPos-2, y+yPos-1, v.value)
      end
  end
  for _,v in pairs(_bg)do
      if(v.value~="")or(v.value~=" ")then
          obj:setBg(x+v.x+xPos-2, y+yPos-1, v.value)
      end
  end
  for _,v in pairs(_fg)do
      if(v.value~="")or(v.value~=" ")then
          obj:setFg(x+v.x+xPos-2, y+yPos-1, v.value)
      end
  end
end

for _,v in pairs({"Text", "Bg", "Fg"})do
    VisualObject["add"..v] = function(self, x, y, str)
      local obj = self.parent or self
      local xPos,yPos = self.x, self.y
      local transparent = self:getTransparent()
      if(self.parent~=nil)then
          local xO, yO = self.parent:getOffset()
          local ignOffset = self:getIgnoreOffset()
          xPos = ignOffset and xPos or xPos - xO
          yPos = ignOffset and yPos or yPos - yO
      end
      if not(transparent)then
          obj["set"..v](obj, x+xPos-1, y+yPos-1, str)
          return
      end
      local t = split(str)
      for _,v in pairs(t)do
          if(v=="Text")then
            if(v.value~="")and(v.value~="\0")then
              obj["set"..v](obj, x+v.x+xPos-2, y+yPos-1, v.value)
            end
          else
            if(v.value~="")and(v.value~=" ")then
              obj["set"..v](obj, x+v.x+xPos-2, y+yPos-1, v.value)
            end
          end
      end
    end
end

function VisualObject.addBlit(self, x, y, t, f, b)
  local obj = self.parent or self
  local xPos,yPos = self.x, self.y
  local transparent = self:getTransparent()
  if(self.parent~=nil)then
      local xO, yO = self.parent:getOffset()
      local ignOffset = self:getIgnoreOffset()
      xPos = ignOffset and xPos or xPos - xO
      yPos = ignOffset and yPos or yPos - yO
  end
  if not(transparent)then
      obj:blit(x+xPos-1, y+yPos-1, t, f, b)
      return
  end
  local _text = split(t, "\0")
  local _fg = split(f)
  local _bg = split(b)
  for _,v in pairs(_text)do
      if(v.value~="")or(v.value~="\0")then
          obj:setText(x+v.x+xPos-2, y+yPos-1, v.value)
      end
  end
  for _,v in pairs(_bg)do
      if(v.value~="")or(v.value~=" ")then
          obj:setBg(x+v.x+xPos-2, y+yPos-1, v.value)
      end
  end
  for _,v in pairs(_fg)do
      if(v.value~="")or(v.value~=" ")then
          obj:setFg(x+v.x+xPos-2, y+yPos-1, v.value)
      end
  end
end

function VisualObject.addRender(self, render, index)
  if(type(render) == "function")then
    local renderRef = self:getRender()
    table.insert(renderRef, index or #renderRef+1, render)
  end
  return self
end

function VisualObject:getRelativePosition(x, y)
  if(x==nil)and(y==nil)then
    x, y = self:getPosition()
  end
  local newX = x - (self.x-1)
  local newY = y - (self.y-1)
  if self:isType("Container") then
    local xO, yO = self:getOffset()
    newX = newX - xO
    newY = newY - yO
  end
  if self.parent ~= nil then
    newX, newY = self.parent:getRelativePosition(newX, newY)
  end
  return newX, newY
end

function VisualObject.getAbsolutePosition(self, x, y)
  if(x==nil)and(y==nil)then
    x, y = self:getPosition()
  end
  local newX = x + (self.x-1)
  local newY = y + (self.y-1)
  if self:isType("Container") then
    local xO, yO = self:getOffset()
    newX = newX + xO
    newY = newY + yO
  end
  if self.parent ~= nil then
    newX, newY = self.parent:getAbsolutePosition(newX, newY)
  end
  return newX, newY
end

local function isInside(self, x, y)
  local p = self
  return x >= p.x and x <= p.x + p.width-1 and y >= p.y and y <= p.y + p.height-1 and p.visible and p.enabled
end
VisualObject.isInside = isInside

function VisualObject.mouse_click(self, btn, x, y)
  if isInside(self, x, y) then
    self:setProperty("clicked", true)
    self:setProperty("dragging", true)
    self:updateRender()
    self:fireEvent("click", btn, x, y)
    return true
  end
end

function VisualObject.mouse_drag(self, btn, x, y)
  if self:getProperty("dragging") then
    self:fireEvent("drag", btn, x, y)
    return true
  end
end

function VisualObject.mouse_up(self, btn, x, y)
  self:setProperty("dragging", false)
  self:setProperty("clicked", false)
  if isInside(self, x, y) then
    self:fireEvent("clickUp", btn, x, y)
    self:updateRender()
    return true
  end
end

function VisualObject:mouse_scroll(direction, x, y)
    if isInside(self, x, y) then
      self:fireEvent("scroll")
      return true
    end
end

function VisualObject:mouse_move(_, x, y)
  if isInside(self, x, y) then
    self:setProperty("hovered", true)
    self:updateRender()
    self:fireEvent("hover", x, y)
    return true
  end
  if(self:getProperty("hovered"))then
    self:setProperty("hovered", false)
    self:updateRender()
    self:fireEvent("leave", x, y)
    return true
  end
end

function VisualObject.get_focus(self)
  self:fireEvent("getFocus")
end

function VisualObject.lose_focus(self)
  self:fireEvent("loseFocus")
end

for _,v in pairs({"key", "key_up", "char"})do
  VisualObject[v] = function(self, ...)
    if(self.enabled)and(self.visible)then
      if(self.parent==nil)or(self:getFocused())then
        self:fireEvent(v, ...)
        return true
      end
    end
  end
end

return VisualObject