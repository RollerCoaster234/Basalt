local objectLoader = require("objectLoader")
local Object = objectLoader.load("Object")
local Container = objectLoader.load("Container")

local BaseFrame = setmetatable({}, Container)

Object:initialize("BaseFrame")

function BaseFrame:new(id, basalt)
  local newInstance = Container:new(id, basalt)
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:setType("BaseFrame")
  newInstance:create("BaseFrame")
  newInstance:setTerm(term.current())
  newInstance:setSize(term.getSize())
  return newInstance
end

function BaseFrame:getSize()
  local baseTerm = self:getProperty("term")
  if(baseTerm~=nil)then
    return baseTerm.getSize()
  else
    return 1, 1
  end
end

function BaseFrame:getWidth()
  return select(1, self:getSize())
end

function BaseFrame:getHeight()
  return select(2, self:getSize())
end

function BaseFrame:getPosition()
  return 1, 1
end

function BaseFrame:event(event, ...)
  Container.event(self, event, ...)
  if(event=="term_resize")then
    self:childVisibiltyChanged()
    self:setSize(term.getSize())
    self:setTerm(term.current())
  end
end

function BaseFrame:mouse_click(...)
  Container.mouse_click(self, ...)
  self.basalt.setFocusedFrame(self)
end

function BaseFrame:lose_focus()
  Container.lose_focus(self)
  self:setCursor(false)
end


return BaseFrame