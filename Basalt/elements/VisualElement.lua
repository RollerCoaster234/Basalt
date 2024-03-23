local Element = require("basaltLoader").load("BasicElement")
local split = require("utils").splitString
local subText = require("utils").subText

--- @class VisualElement: VisualElementL
local VisualElement = setmetatable({}, Element)

local function BaseRender(self)
  local w, h = self:getSize()
  self:addTextBox(1, 1, w, h, " ")
  self:addBackgroundBox(1, 1, w, h, self:getBackground())
  self:addForegroundBox(1, 1, w, h, self:getForeground())
end

Element:initialize("VisualElement")
Element:addProperty("background", "color", colors.black)
Element:addProperty("foreground", "color", colors.white)
Element:addProperty("x", "number", 1)
Element:addProperty("y", "number", 1)

Element:combineProperty("Position", "X", "Y")
Element:addProperty("visible", "boolean", true)
Element:addProperty("width", "number", 1)
Element:addProperty("height", "number", 1)
Element:addProperty("renderData", "table", {BaseRender}, false, function(self, value)
  if(type(value)=="function")then
    table.insert(self.renderData, value)
    return self.renderData
  end
end)

Element:combineProperty("Size", "width", "height")
Element:addProperty("transparency", "boolean", false)
Element:addProperty("ignoreOffset", "boolean", false)
Element:addProperty("focused", "boolean", false, nil, function(self, value)
  if(value)then
    self:get_focus()
  else
    self:lose_focus()
  end
end)

Element:addListener("click", "mouse_click")
Element:addListener("drag", "mouse_drag")
Element:addListener("scroll", "mouse_scroll")
Element:addListener("hover", "mouse_move")
Element:addListener("leave", "mouse_move2")
Element:addListener("clickUp", "mouse_up")
Element:addListener("key", "key")
Element:addListener("keyUp", "key_up")
Element:addListener("char", "char")
Element:addListener("getFocus", "get_focus")
Element:addListener("loseFocus", "lose_focus")
Element:addListener("release", "mouse_release")

--- Creates a new visual element.
---@param id string The id of the object.
---@param parent? Container The parent of the object.
---@param basalt Basalt The basalt object.
--- @return VisualElement
---@protected
function VisualElement:new(id, parent, basalt)
  local newInstance = Element:new(id, parent, basalt)
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:create("VisualElement")
  newInstance:setType("VisualElement")
  return newInstance
end

---@protected
function VisualElement.render(self)
    for _,v in pairs(self.renderData)do
      v(self)
    end
end

for _,v in pairs({"BackgroundBox", "TextBox", "ForegroundBox"})do
  ---@protected
  VisualElement["add"..v] = function(self, x, y, w, h, col)
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

---@protected
function VisualElement.blit(self, x, y, t, fg, bg)
  local obj = self.parent or self
  local xPos,yPos = self:getPosition()
  local transparent = self:getTransparency()
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
    VisualElement["add"..v] = function(self, x, y, str, ignoreElementSize)
      local obj = self.parent or self
      local xPos,yPos = self:getPosition()
      local w, h = self:getSize()
      local transparent = self:getTransparency()
      if(self.parent~=nil)then
          local xO, yO = self.parent:getOffset()
          local ignOffset = self:getIgnoreOffset()
          xPos = ignOffset and xPos or xPos - xO
          yPos = ignOffset and yPos or yPos - yO
      end
      if not(ignoreElementSize)then
        str, x = subText(str, x, w)
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

--- @protected
function VisualElement.addBlit(self, x, y, t, f, b)
  local obj = self.parent or self
  local xPos,yPos = self:getPosition()
  local transparent = self:getTransparency()
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

--- Adds a render function to the element which will be called when the element is rendered.
---@param func function -- The render function.
---@param index? number -- The index in the render table.
---@return self
function VisualElement.addRender(self, func, index)
  if(type(func) == "function")then
    local renderRef = self:getRenderData()
    table.insert(renderRef, index or #renderRef+1, func)
  end
  return self
end

--- Returns the relative position of the element or the given coordinates.
---@param x? number -- The x position.
---@param y? number -- The y position.
---@return number, number
function VisualElement:getRelativePosition(x, y)
  if(x==nil)and(y==nil)then
    x, y = self:getPosition()
  end
  local xObj, yObj = self:getPosition()
  local newX = x - (xObj-1)
  local newY = y - (yObj-1)
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

--- Returns the absolute position of the element or the given coordinates.
---@param x? number -- The x position.
---@param y? number -- The y position.
function VisualElement.getAbsolutePosition(self, x, y)
  if(x==nil)and(y==nil)then
    x, y = self:getPosition()
  end
  local xObj, yObj = self:getPosition()
  local newX = x + (xObj-1)
  local newY = y + (yObj-1)
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
  local pX, pY = self:getPosition()
  local pW, pH = self:getSize()
  local visible, enabled = self:getVisible(), self:getEnabled()
  return x >= pX and x <= pX + pW-1 and y >= pY and y <= pY + pH-1 and visible and enabled
end

--- Returns whether the given coordinates are inside the element.
---@param x number -- The x position.
---@param y number -- The y position.
---@return boolean
VisualElement.isInside = isInside

---@protected
function VisualElement.mouse_click(self, btn, x, y)
  if isInside(self, x, y) then
    self:setProperty("clicked", true)
    self:setProperty("dragging", true)
    self:updateRender()
    self:fireEvent("click", btn, x, y)
    return true
  end
end

---@protected
function VisualElement.mouse_drag(self, btn, x, y)
  if self:getProperty("dragging") then
    self:fireEvent("drag", btn, x, y)
    return true
  end
end

---@protected
function VisualElement.mouse_up(self, btn, x, y)
  if isInside(self, x, y) then
    self:fireEvent("clickUp", btn, x, y)
    self:updateRender()
    return true
  end
end

---@protected
function VisualElement.mouse_release(self, btn, x, y)
  self:setProperty("dragging", false)
  self:setProperty("clicked", false)
  self:fireEvent("release", btn, x, y)
  return true
end

---@protected
function VisualElement:mouse_scroll(direction, x, y)
    if isInside(self, x, y) then
      self:fireEvent("scroll")
      return true
    end
end

---@protected
function VisualElement:mouse_move(_, x, y)
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

---@protected
function VisualElement.get_focus(self)
  self:fireEvent("getFocus")
end

---@protected
function VisualElement.lose_focus(self)
  self:fireEvent("loseFocus")
end

for _,v in pairs({"key", "key_up", "char"})do
  ---@protected
  VisualElement[v] = function(self, ...)
    if(self.enabled)and(self.visible)then
      if(self.parent==nil)or(self:getFocused())then
        self:fireEvent(v, ...)
        return true
      end
    end
  end
end

return VisualElement