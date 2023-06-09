local Container = require("objectLoader").load("Container")

local Frame = Container.new(Container)

Frame:setPropertyType("Frame")

function Frame:new()
  local newInstance = setmetatable({}, self)
  self.__index = self
  newInstance:setType("Frame")
  newInstance:addDefaultProperties("Frame")
  newInstance:setSize(10, 10)
  return newInstance
end

return Frame