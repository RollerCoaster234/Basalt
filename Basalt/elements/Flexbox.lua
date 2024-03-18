local Container = require("basaltLoader").load("Container")

local Flexbox = setmetatable({}, Container)

Flexbox:initialize("Flexbox")

function Flexbox:new(id, parent, basalt)
  local newInstance = Container:new(id, parent, basalt)
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:setType("Flexbox")
  newInstance:create("Flexbox")
  newInstance:setZ(10)
  newInstance:setSize(30, 12)
  return newInstance
end

return Flexbox