local objectLoader = require("objectLoader")
local VisualObject = objectLoader.load("VisualObject")
local Container = VisualObject.new(VisualObject)

local basaltRender = require("basaltRender")

local basaltTerm = term.current()
basaltTerm.__noCopy = true

Container:initialize("Container")
Container:addProperty("term", "table", basaltTerm, false, function(self, value)
  self.basaltRender = basaltRender(value)
end)
Container:addProperty("Children", "table", {})
Container:addProperty("ChildrenByName", "table", {})
Container:addProperty("ChildrenEvents", "table", {})
Container:addProperty("cursorBlink", "boolean", false)
Container:addProperty("cursorColor", "color", colors.white)
Container:addProperty("cursorX", "number", 1)
Container:addProperty("cursorY", "number", 1)
Container:addProperty("focusedChild", "table", nil, false, function(self, value)
  local curFocus = self:getFocusedChild()
  if(curFocus~=value)then
    if(curFocus~=nil)then
      curFocus:setFocused(false, true)
    end
    if(value~=nil)then
      value:setFocused(true, true)
    end
  end
  return value
end)
Container:addProperty("ElementsSorted", "boolean", true)
Container:addProperty("XOffset", "number", 0)
Container:addProperty("YOffset", "number", 0)
Container:combineProperty("Offset", "XOffset", "YOffset")

local sub, max = string.sub, math.max

function Container:new()
  local newInstance = setmetatable({}, self)
  self.__index = self
  newInstance:create("Container")
  newInstance:setType("Container")
  self.basaltRender = basaltRender(basaltTerm)
  return newInstance
end

function Container.render(self)
  if(self.parent==nil)then
    if(self.updateRendering)then
      VisualObject.render(self)
      for _,v in pairs(self.Children) do
        for _,element in pairs(v)do
          element:render()
        end
      end
    end
  else
    VisualObject.render(self)
    for _,v in pairs(self.Children) do
      for _,element in pairs(v)do
        element:render()
      end
    end
  end
end

function Container.processRender(self)
  if(self.updateRendering)then
    self.basaltRender.update()
    self.updateRendering = false
  end
end

function Container.getChild(self, name)
  local index = self.ChildrenByName[name]
  if index then
    return self.Children[index]
  end
end

function Container.getDeepChild(self, name)
  local index = self.ChildrenByName[name]
  if index then
    return self.Children[index]
  end
  for _,v in pairs(self.Children) do
    if v:getType() == "Container" then
      local child = v:getDeepChild(name)
      if child then
        return child
      end
    end
  end
end

function Container:addChild(child)
  child:setParent(self)
  local zIndex = child:getZ()

  if not self.Children[zIndex] then
    self.Children[zIndex] = {}
  end

  table.insert(self.Children[zIndex], child)
  child:init()
  self.ChildrenByName[child:getName()] = #self.Children[zIndex]
  return child
end


function Container.removeChild(self, child)
  if type(child) == "string" then
    child = self:getChild(child)
  end
  local index = self.ChildrenByName[child:getName()]
  if index then
    child:setParent(nil)
    table.remove(self.Children, index)
    self.ChildrenByName[child:getName()] = nil
  end
end

function Container.removeChildren(self)
  for _,v in pairs(self.Children) do
    self:removeChild(v)
  end
  self.Children = {}
  self.ChildrenByName = {}
end

function Container.searchChildren(self, name)
  local children = {}
  for _,v in pairs(self.Children) do
    if v:find(name) then
      table.insert(children, v)
    end
  end
  return children
end

function Container.getChildrenByType(self, type)
  local children = {}
  for _,v in pairs(self.Children) do
    if v:getType() == type then
      table.insert(children, v)
    end
  end
  return children
end

function Container:prioritizeElement(element)
  local zIndex = element:getZ()
  local index = self.ChildrenByName[element:getName()]

  table.remove(self.Children[zIndex], index)
  table.insert(self.Children[zIndex], element)
  self.ChildrenByName[element:getName()] = #self.Children[zIndex]

  for event, _ in pairs(self.ChildrenEvents[zIndex]) do
      local eventData = self:getEvent(event, element)
      if eventData then
          table.remove(self.ChildrenEvents[zIndex][event], eventData.index)
          table.insert(self.ChildrenEvents[zIndex][event], eventData)
          eventData.index = #self.ChildrenEvents[zIndex][event]
      end
  end
end

function Container:getEvent(event, child)
  if type(child) == "string" then
    child = self:getChild(child)
  end

  local zIndex = child:getZ()
  local eventArray = self.ChildrenEvents[zIndex] and self.ChildrenEvents[zIndex][event]

  if eventArray then
    for index, eventData in ipairs(eventArray) do
      if eventData == child then
        return eventData, index
      end
    end
  end
end

function Container:addEvent(event, child)
  if type(child) == "string" then
    child = self:getChild(child)
  end

  local zIndex = child:getZ()
  if(self:getEvent(event, child)) then
    return
  end
  if not self.ChildrenEvents[zIndex] then
    self.ChildrenEvents[zIndex] = {}
  end
  if not self.ChildrenEvents[zIndex][event] then
    self.ChildrenEvents[zIndex][event] = {}
  end

  table.insert(self.ChildrenEvents[zIndex][event], child)
end

function Container:removeEvent(event, child)
  if type(child) == "string" then
    child = self:getChild(child)
  end

  local zIndex = child:getZ()
  if self.ChildrenEvents[zIndex] and self.ChildrenEvents[zIndex][event] then
    for i, eventData in ipairs(self.ChildrenEvents[zIndex][event]) do
      if eventData == child then
        table.remove(self.ChildrenEvents[zIndex][event], i)
        break
      end
    end
    if #self.ChildrenEvents[zIndex][event] == 0 then
      self.ChildrenEvents[zIndex][event] = nil
    end
    if next(self.ChildrenEvents[zIndex]) == nil then
      self.ChildrenEvents[zIndex] = nil
    end
  end
end

function Container:updateChildZIndex(child, oldZ, newZ)
  local index = self.ChildrenByName[child:getName()]
  table.remove(self.Children[oldZ], index)
  if #self.Children[oldZ] == 0 then
    self.Children[oldZ] = nil
  end
  if not self.Children[newZ] then
    self.Children[newZ] = {}
  end
  table.insert(self.Children[newZ], child)
  self.ChildrenByName[child:getName()] = #self.Children[newZ]

  for event, _ in pairs(self.ChildrenEvents[oldZ] or {}) do
    for i, eventData in ipairs(self.ChildrenEvents[oldZ][event] or {}) do
      if eventData.element == child then
        table.remove(self.ChildrenEvents[oldZ][event], i)
        if #self.ChildrenEvents[oldZ][event] == 0 then
          self.ChildrenEvents[oldZ][event] = nil
        end
        if next(self.ChildrenEvents[oldZ]) == nil then
          self.ChildrenEvents[oldZ] = nil
        end
        if not self.ChildrenEvents[newZ] then
          self.ChildrenEvents[newZ] = {}
        end
        if not self.ChildrenEvents[newZ][event] then
          self.ChildrenEvents[newZ][event] = {}
        end
        table.insert(self.ChildrenEvents[newZ][event], eventData)
        break
      end
    end
  end
end

Container.setCursor = function(self, blink, cursorX, cursorY, color)
  if(self.parent~=nil) then
    local obx, oby = self:getPosition()
    local xO, yO = self:getOffset()
    self.parent:setCursor(blink or false, (cursorX or 0)+obx-1 - xO, (cursorY or 0)+oby-1 - yO, color or self.foreground)
  else
    local obx, oby = self:getAbsolutePosition()
    local xO, yO = self:getOffset()
    self.cursorBlink = blink or false
    if (cursorX ~= nil) then
        self.cursorX = obx + cursorX - 1 - xO
    end
    if (cursorY ~= nil) then
        self.cursorY = oby + cursorY - 1 - yO
    end
    self.cursorColor = color or self.cursorColor
    if (self.cursorBlink) then
        self.term.setTextColor(self.cursorColor)
        self.term.setCursorPos(self.cursorX, self.cursorY)
        self.term.setCursorBlink(true)
    else
      self.term.setCursorBlink(false)
    end
  end
    return self
end

for _,v in pairs({"setBg", "setFg", "setText"}) do
  Container[v] = function(self, x, y, str)
    local obx, oby, w, h = self.x, self.y, self.width, self.height
      if (y >= 1) and (y <= h) then
          local pos = max(x + (obx - 1), obx)
          if self.parent then
              self.parent[v](pos, oby + y - 1, str)
          else
              local str_visible = sub(str, max(1 - x + 1, 1), max(w - x + 1, 1))
              self.basaltRender[v](pos, oby + y - 1, str_visible)
          end
      end
  end
end

for _,v in pairs({"drawBackgroundBox", "drawForegroundBox", "drawTextBox"})do
  Container[v] = function(self, x, y, width, height, symbol)
      local obx, oby, w, h = self.x, self.y, self.width, self.height
      height = (y < 1 and (height + y > h and h or height + y - 1) or (height + y > h and h - y + 1 or height))
      width = (x < 1 and (width + x > w and w or width + x - 1) or (width + x > w and w - x + 1 or width))
      local pos = max(x + (obx - 1), obx)
      if self.parent then
          self.parent:drawBackgroundBox(pos, max(y + (oby - 1), oby), width, height, symbol)
      else
        self.basaltRender[v](pos, max(y + (oby - 1), oby), width, height, symbol)
      end
  end
end

Container.blit = function(self, x, y, t, f, b)
  local obx, oby, w, h = self.x, self.y, self.width, self.height
  if y >= 1 and y <= h then
      local pos = max(x + (obx - 1), obx)
      if self.parent then
          self.parent.blit(pos, oby + y - 1, t, f, b)
      else
        self.basaltRender.blit(pos, oby + y - 1, t, f, b, x, w)
      end
  end
end

for k,v in pairs({mouse_click=true,mouse_up=false,mouse_drag=false,mouse_scroll=true,mouse_move=false})do
  Container[k] = function(self, btn, x, y, ...)
      if(VisualObject[k]~=nil)then
          if(VisualObject[k](self, btn, x, y, ...))then
            for _,event in pairs(self.ChildrenEvents)do
              if(event and event[k]~=nil)then
                  for _, obj in pairs(event[k]) do
                      if (obj and obj[k] ~= nil) then
                          local relX, relY = self:getRelativePosition(x, y)
                          if (obj[k](obj, btn, relX, relY, ...)) then
                              self:setFocusedChild(obj, true)
                              return true
                          end
                      end
                  end
              if(v)then
                  self:setFocusedChild(nil, true)
              end
              end
            end
            return true
          end
      end
  end
end

for _,v in pairs({"key", "key_up", "char"})do
  Container[v] = function(self, ...)
      if(VisualObject[v]~=nil)then
          if(VisualObject[v](self, ...))then
            local focused = self:getFocusedChild()
            if(focused)then
                if(focused[v]~=nil)then
                    if(focused[v](focused, ...))then
                        return true
                    end
                end
            end
            return true
          end
      end
  end
end

for _,v in pairs(objectLoader.getObjectList())do
  local fName = v:gsub("^%l", string.upper)
  Container["add"..fName] = function(self, id)
    local obj = objectLoader.load(v):new()
    self:addChild(obj)
    return obj
  end
end

return Container