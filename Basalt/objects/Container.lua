local objectLoader = require("objectLoader")
local Object = objectLoader.load("Object")
local VisualObject = objectLoader.load("VisualObject")
local Container = setmetatable({}, VisualObject)

local function reverse(tbl)
  local size = #tbl
  local new_table = {}

  for i, v in pairs(tbl) do
    new_table[size - i + 1] = v
  end

  return new_table
end

local basaltRender = require("basaltRender")

Object:initialize("Container")
Object:addProperty("term", "table", nil, false, function(self, value)
  if(value~=nil)then
    value.__noCopy = true
  end
  self.basaltRender = basaltRender(value)
end)
Object:addProperty("Children", "table", {})
Object:addProperty("ChildrenByName", "table", {})
Object:addProperty("ChildrenEvents", "table", {})
Object:addProperty("cursorBlink", "boolean", false)
Object:addProperty("cursorColor", "color", colors.white)
Object:addProperty("cursorX", "number", 1)
Object:addProperty("cursorY", "number", 1)
Object:addProperty("focusedChild", "table", nil, false, function(self, value)
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
Object:addProperty("ElementsSorted", "boolean", true)
Object:addProperty("XOffset", "number", 0)
Object:addProperty("YOffset", "number", 0)
Object:combineProperty("Offset", "XOffset", "YOffset")

local sub, max = string.sub, math.max

function Container:new(id, basalt)
  local newInstance = VisualObject:new(id, basalt)
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:create("Container")
  newInstance:setType("Container")
  return newInstance
end

function Container:render()
  if(self:getTerm()==nil)then
    return
  end
  if not self.ElementsSorted then
    self.sortedZIndices = {}
    for zIndex, _ in pairs(self.Children) do
      table.insert(self.sortedZIndices, zIndex)
    end
    table.sort(self.sortedZIndices)
    self.ElementsSorted = true
  end

  if self.parent == nil then
    if self.updateRendering then
      VisualObject.render(self)
      for _, zIndex in ipairs(self.sortedZIndices) do
        for _, element in pairs(self.Children[zIndex]) do
          element:render()
        end
      end
    end
  else
    VisualObject.render(self)
    for _, zIndex in ipairs(self.sortedZIndices) do
      for _, element in pairs(self.Children[zIndex]) do
        element:render()
      end
    end
  end
end


function Container:processRender()
  if(self.updateRendering)then
    if(self.basaltRender~=nil)then
      self.basaltRender.update()
      self.updateRendering = false
    end
  end
end

function Container:getChild(name)
  local index = self.ChildrenByName[name]
  if index then
    return self.Children[index]
  end
end

function Container:getDeepChild(name)
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
    --table.insert(self.Children, zIndex, {})
    self.Children[zIndex] = {}
  end

  table.insert(self.Children[zIndex], child)
  child.basalt = self.basalt
  child:init()
  self.ChildrenByName[child:getName()] = #self.Children[zIndex]
  self.ElementsSorted = false
  return child
end

function Container:removeChild(child)
  if type(child) == "string" then
    child = self:getChild(child)
  end
  local index = self.ChildrenByName[child:getName()]
  if index then
    child:setParent(nil)
    table.remove(self.Children, index)
    self.ChildrenByName[child:getName()] = nil
  end
  self.ElementsSorted = false
end

function Container:removeChildren()
  for _,v in pairs(self.Children) do
    self:removeChild(v)
  end
  self.Children = {}
  self.ChildrenByName = {}
  self.ElementsSorted = false
end

function Container:searchChildren(name)
  local children = {}
  for _,v in pairs(self.Children) do
    if v:find(name) then
      table.insert(children, v)
    end
  end
  return children
end

function Container:getChildrenByType(type)
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
  self.ElementsSorted = false
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

function Container:setCursor(blink, cursorX, cursorY, color)
  if(self.parent~=nil) then
    local obx, oby = self:getPosition()
    local xO, yO = self:getOffset()
    self.parent:setCursor(blink or false, (cursorX or 0)+obx-1 - xO, (cursorY or 0)+oby-1 - yO, color or self:getForeground())
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

function Container:blit(x, y, t, f, b)
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

function Container:event(event, ...)
  for _, child in pairs(self.Children) do
      for _, obj in pairs(child) do
          if obj.event then
              obj:event(event, ...)
          end
      end
  end
end

for k,v in pairs({mouse_click=true,mouse_up=false,mouse_drag=false,mouse_scroll=true,mouse_move=false})do
  Container[k] = function(self, btn, x, y, ...)
      if(VisualObject[k]~=nil)then
          if(VisualObject[k](self, btn, x, y, ...))then
            for _,event in pairs(reverse(self.ChildrenEvents))do
              if(event and event[k]~=nil)then
                  for _, obj in pairs(reverse(event[k])) do
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

for k,_ in pairs(objectLoader.getObjectList())do
  local fName = k:gsub("^%l", string.upper)
  Container["add"..fName] = function(self, id)
    local obj = objectLoader.load(k):new(id, self.basalt)
    self:addChild(obj)
    return obj
  end
end

return Container