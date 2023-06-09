local Container = require("objectLoader").load("Container")

local BaseFrame = Container.new(Container)

BaseFrame:setPropertyType("BaseFrame")

function BaseFrame:new()
  local newInstance = setmetatable({}, self)
  self.__index = self
  newInstance:setType("BaseFrame")
  newInstance:addDefaultProperties("BaseFrame")
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


return BaseFrame