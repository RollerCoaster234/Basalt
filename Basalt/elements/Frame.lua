local Container = require("basaltLoader").load("Container")

local Frame = setmetatable({}, Container)

Frame:initialize("Frame")

function Frame:new(id, parent, basalt)
  local newInstance = Container:new(id, parent, basalt)
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:setType("Frame")
  newInstance:create("Frame")
  newInstance:setZ(10)
  newInstance:setSize(30, 12)
  return newInstance
end

return Frame