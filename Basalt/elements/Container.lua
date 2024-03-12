local loader = require("basaltLoader")
local Element = loader.load("BasicElement")
local VisualElement = loader.load("VisualElement")
local Container = setmetatable({}, VisualElement)
local uuid = require("utils").uuid

local function rpairs(t)
  local keys = {}
  for k in pairs(t) do
      if type(k) == "number" then
          table.insert(keys, k)
      end
  end
  table.sort(keys, function(a, b) return a > b end)

  local i = 0
  local function iter(tbl)
      i = i + 1
      if keys[i] then
          return keys[i], tbl[keys[i]]
      end
  end

  return iter, t
end

local renderSystem = require("renderSystem")

Element:initialize("Container")
Element:addProperty("term", "table", nil, false, function(self, value)
  if(value~=nil)then
    value.__noCopy = true
  end
  self.renderSystem = renderSystem(value)
end)
Element:addProperty("children", "table", {})
Element:addProperty("childrenEvents", "table", {})
Element:addProperty("visibleChildrenEvents", "table", {})
Element:addProperty("isVisibleChildrenEventsUpdated", "table", {})
Element:addProperty("cursorBlink", "boolean", false)
Element:addProperty("cursorColor", "color", colors.white)
Element:addProperty("cursorX", "number", 1)
Element:addProperty("cursorY", "number", 1)
Element:addProperty("focusedChild", "table", nil, false, function(self, value)
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
Element:addProperty("XOffset", "number", 0)
Element:addProperty("YOffset", "number", 0)
Element:combineProperty("Offset", "XOffset", "YOffset")

local sub, max = string.sub, math.max

function Container:new(id, parent, basalt)
  local newInstance = VisualElement:new(id, parent, basalt)
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:create("Container")
  newInstance:setType("Container")
  return newInstance
end

function Container:render()
  if(self:getTerm()==nil)then
    --return
  end

  local visibleChildren = self:getVisibleChildren()
  if self.parent == nil then
    if self.updateRendering then
      VisualElement.render(self)
        for _, element in pairs(visibleChildren) do
            element:render()
        end
    end
  else
    VisualElement.render(self)
    for _, element in pairs(visibleChildren) do
      element:render()
    end
  end
end


function Container:processRender()
  if(self.updateRendering)then
    if(self.renderSystem~=nil)then
      self.renderSystem.update()
      self.updateRendering = false
    end
  end
end

function Container:getVisibleChildren()
  if(self.isVisibleChildrenUpdated)then
    return self.visibleChildren
  end
  local visibleChildren = {}
  for _, child in ipairs(self.children) do
      if self:isChildVisible(child) then
          table.insert(visibleChildren, child)
      end
  end
  self.visibleChildren = visibleChildren
  self.isVisibleChildrenUpdated = true
  return visibleChildren
end

function Container:isChildVisible(child)
  local childX, childY = child:getPosition()
  local childWidth, childHeight = child:getSize()
  local containerWidth, containerHeight = self:getSize()

  return child:getVisible() and
         childX <= containerWidth and childY <= containerHeight and
         childX + childWidth > 0 and childY + childHeight > 0
end

function Container:forceVisibleChildrenUpdate()
  self.isVisibleChildrenUpdated = false
  for k,v in pairs(self.isVisibleChildrenEventsUpdated)do
    self.isVisibleChildrenEventsUpdated[k] = false
  end
end

function Container:getChild(name)
  if(type(name)=="table")then
    name = name:getName()
  end
  for _, childObj in ipairs(self.children) do
    if childObj:getName() == name then
      return childObj
    end
  end
end

function Container:addChild(child, childZ)
  if(self:getChild(child) ~= nil) then
    return
  end
  local inserted = false
  local pos = 1
  childZ = childZ or child:getZ()
  for i, registeredChild in ipairs(self.children) do
    local registeredChildZ = registeredChild:getZ()
    if childZ > registeredChildZ then
      table.insert(self.children, i+1, child)
      inserted = true
      break
    end
    if(childZ == registeredChildZ)then
      pos = i+1
    end
  end
  if not inserted then
    table.insert(self.children, pos, child)
  end
  child:setParent(self)
  child.basalt = self.basalt
  child:init()
  self.isVisibleChildrenUpdated = false
  return child
end

function Container:removeChild(childName)
  if(type(childName)=="table")then
    childName = childName:getName()
  end
  for i, childObj in ipairs(self.children) do
    if childObj:getName() == childName then
      table.remove(self.children, i)
      break
    end
  end
  self.isVisibleChildrenUpdated = false
end

function Container:isEventRegistered(event, child)
  if(self.childrenEvents[event]==nil)then
    return false
  end
  for _, registeredChild in ipairs(self.childrenEvents[event]) do
    if registeredChild == child then
      return true
    end
  end
  return false
end

function Container:addEvent(event, child)
  self.childrenEvents[event] = self.childrenEvents[event] or {}
  if(self:isEventRegistered(event, child))then
    return
  end
  local inserted = false
  for i, registeredChild in ipairs(self.childrenEvents[event]) do
    if child:getZ() >= registeredChild:getZ() then
      table.insert(self.childrenEvents[event], i, child)
      inserted = true
      break
    end
  end

  if not inserted then
    table.insert(self.childrenEvents[event], 1, child)
  end
  if(self.parent~=nil)then
    self.parent:addEvent(event, self)
  end
  self.isVisibleChildrenEventsUpdated[event] = false
end

function Container:removeEvent(event, child)
  if(self.childrenEvents[event]==nil)then
    return false
  end
  for i, registeredChild in ipairs(self.childrenEvents[event]) do
    if registeredChild == child then
      table.remove(self.childrenEvents[event], i)
      self.isVisibleChildrenEventsUpdated[event] = false
      if(self.parent~=nil)then
        if(#self.childrenEvents[event]==0)then
          self.parent:removeEvent(event, self)
        end
      end
      return true
    end
  end
  return false
end

function Container:getVisibleChildrenEvents(event)
  if(self.isVisibleChildrenEventsUpdated[event])then
    return self.visibleChildrenEvents[event]
  end
  local visibleChildrenEvents = {}

  if self.childrenEvents[event] then
    for _, child in ipairs(self.childrenEvents[event]) do
      if self:isChildVisible(child) then
        table.insert(visibleChildrenEvents, child)
      end
    end
  end

  self.visibleChildrenEvents[event] = visibleChildrenEvents
  self.isVisibleChildrenEventsUpdated[event] = true
  return visibleChildrenEvents
end

function Container:updateChild(child)
  if not child or type(child) ~= "table" then
    return
  end

  self:removeChild(child)
  self:addChild(child, child:getZ())

  for event, _ in pairs(self.childrenEvents) do
    if self:isEventRegistered(event, child) then
      self:removeEvent(event, child)
      self:addEvent(event, child)
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
    local obx, oby = self:getPosition()
    local w, h = self:getSize()
      if (y >= 1) and (y <= h) then
          local pos = max(x + (obx - 1), obx)
          local str_visible = sub(str, max(1 - x + 1, 1), max(w - x + 1, 1))
          if self.parent then
              self.parent[v](self.parent, pos, oby + y - 1, str_visible)
          else
              self.renderSystem[v](pos, oby + y - 1, str_visible)
          end
      end
  end
end

for _,v in pairs({"drawBackgroundBox", "drawForegroundBox", "drawTextBox"})do
  Container[v] = function(self, x, y, width, height, symbol)
      local obx, oby = self:getPosition()
      local w, h = self:getSize()
      height = (y < 1 and (height + y > h and h or height + y - 1) or (height + y > h and h - y + 1 or height))
      width = (x < 1 and (width + x > w and w or width + x - 1) or (width + x > w and w - x + 1 or width))
      local pos = max(x + (obx - 1), obx)
      if self.parent then
          self.parent[v](self.parent, pos, max(y + (oby - 1), oby), width, height, symbol)
      else
        self.renderSystem[v](pos, max(y + (oby - 1), oby), width, height, symbol)
      end
  end
end

function Container:blit(x, y, t, f, b)
  local obx, oby = self:getPosition()
  local w, h = self:getSize()
  if y >= 1 and y <= h then
      local pos = max(x + (obx - 1), obx)
      if self.parent then
          self.parent.blit(pos, oby + y - 1, t, f, b)
      else
        self.renderSystem.blit(pos, oby + y - 1, t, f, b, x, w)
      end
  end
end

function Container:event(event, ...)
  VisualElement.event(self, event, ...)
  for _, child in ipairs(self.children) do
      if child.event then
        child:event(event, ...)
      end
  end
end

for k,v in pairs({mouse_click=true,mouse_up=false,mouse_drag=false,mouse_scroll=true,mouse_move=false})do
  Container[k] = function(self, btn, x, y, ...)
      if(VisualElement[k]~=nil)then
          if(VisualElement[k](self, btn, x, y, ...))then
            local visibleChildren = self:getVisibleChildrenEvents(k)
            for _,child in pairs(visibleChildren)do
              if(child and child[k]~=nil)then
                local objX, objY = child:getPosition()
                local relX, relY = self:getRelativePosition(x, y)
                if(child[k](child, btn, relX, relY, ...))then
                  self:setFocusedChild(child, true)
                  return true
                end
              end
            end
            if(v)then
              self:setFocusedChild(nil, true)
            end
            return true
          end
      end
  end
end


for _,v in pairs({"key", "key_up", "char"})do
  Container[v] = function(self, ...)
      if(VisualElement[v]~=nil)then
          if(VisualElement[v](self, ...))then
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

for k,_ in pairs(loader.getElementList())do
  local elementName = k:gsub("^%l", string.upper)
  Container["add"..elementName] = function(self, id)
    local element = self.basalt.create(id or uuid(), self, k)
    self:addChild(element, element:getZ())
    return element
  end
end

return Container