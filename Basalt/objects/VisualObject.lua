local Object = require("objectLoader").load("Object")
local split = require("utils").splitString

local VisualObject = Object.new(Object)

local function BaseRender(self)
  self:addBackgroundBox(1, 1, self.width, self.height, self.background)
  self:addForegroundBox(1, 1, self.width, self.height, self.foreground)
end

VisualObject:setPropertyType("VisualObject")
VisualObject:addProperty("background", "color", colors.black)
VisualObject:addProperty("foreground", "color", colors.white)
VisualObject:addProperty("x", "number", 1)
VisualObject:addProperty("y", "number", 1)
VisualObject:combineProperty("Position", "X", "Y")
VisualObject:addProperty("visible", "boolean", true)
VisualObject:addProperty("width", "number", 1)
VisualObject:addProperty("height", "number", 1)
VisualObject:addProperty("renderData", "table", {BaseRender}, false, function(self, value)
  if(type(value)=="function")then
    table.insert(self.renderData, value)
  end
  return self.renderData
end)
VisualObject:combineProperty("Size", "width", "height")
VisualObject:addProperty("transparent", "boolean", false)
VisualObject:addProperty("ignoreOffset", "boolean", false)
VisualObject:addProperty("focused", "boolean", false, nil, function(self, value)
  if(value)then
    self:get_focus()
  else
    self:lose_focus()
  end
end)

VisualObject:addListener("click", "mouse_click")
VisualObject:addListener("drag", "mouse_drag")
VisualObject:addListener("scroll", "mouse_scroll")
VisualObject:addListener("hover", "mouse_hover")
VisualObject:addListener("clickUp", "mouse_up")
VisualObject:addListener("key", "key")
VisualObject:addListener("keyUp", "key_up")
VisualObject:addListener("char", "char")
VisualObject:addListener("getFocus", "get_focus")
VisualObject:addListener("loseFocus", "lose_focus")



function VisualObject:new()
  local newInstance = setmetatable({}, self)
  self.__index = self
  newInstance:addDefaultProperties("VisualObject")
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
    local xPos,yPos = self.x, self.y
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
    VisualObject["add"..v] = function(self, x, y, str, noText)
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

function VisualObject.addRender(self, render, index)
  if(type(render) == "function")then
    local renderRef = self:getRender()
    table.insert(renderRef, index or #renderRef+1, render)
  end
  return self
end

function VisualObject.getRelativePosition(self, x, y)
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
    self:setProperty("Dragging", true)
    self:trigger("click", btn, x, y)
    return true
  end
end

function VisualObject.mouse_drag(self, btn, x, y)
  if self:getProperty("Dragging") then
    --print("Dragging", x, y)
  end
end

function VisualObject.mouse_up(self, btn, x, y)
  self:setProperty("Dragging", false)
  if isInside(self, x, y) then

  end
end

function VisualObject.get_focus(self)
  self:trigger("getFocus")
end

function VisualObject.lose_focus(self)
  self:trigger("loseFocus")
end

for _,v in pairs({"key", "key_up", "char"})do
  VisualObject[v] = function(self, ...)
    if(self.enabled)and(self.visible)then
      if(self.parent==nil)or(self.focused)then
        self:trigger(v, ...)
        return true
      end
    end
  end
end

return VisualObject