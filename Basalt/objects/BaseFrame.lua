local Container = require("objectLoader").load("Container")

local BaseFrame = Container.new(Container)

BaseFrame:initialize("BaseFrame")

function BaseFrame:new()
  local newInstance = setmetatable({}, self)
  self.__index = self
  newInstance:setType("BaseFrame")
  newInstance:create("BaseFrame")
  newInstance:setSize(term.getSize())
  return newInstance
end

function BaseFrame.getSize(self)
  return self:getProperty("Term").getSize()
end

function BaseFrame.getWidth(self)
  return select(1, self:getSize())
end

function BaseFrame.getHeight(self)
  return select(2, self:getSize())
end

function BaseFrame.getPosition(self)
  return 1, 1
end

function BaseFrame.event(self, event, ...)
  if(event=="term_resize")then
    self:setSize(term.getSize())
    self:setTerm(term.current())
  end
end


return BaseFrame