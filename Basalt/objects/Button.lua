local VisualObject = require("objectLoader").load("VisualObject")

local Button = VisualObject.new(VisualObject)

Button:setPropertyType("Button")

function Button:new()
  local newInstance = setmetatable({}, self)
  self.__index = self
  newInstance:setType("Button")
  newInstance:addDefaultProperties("Button")
  newInstance:setSize(10, 3)
  return newInstance
end

return Button