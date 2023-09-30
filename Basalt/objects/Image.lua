local objectLoader = require("objectLoader")
local Object = objectLoader.load("Object")
local VisualObject = objectLoader.load("VisualObject")


local Image = setmetatable({}, VisualObject)

Object:initialize("Image")

function Image:new()
  local newInstance = VisualObject:new()
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:setType("Image")
  newInstance:create("Image")
  newInstance:setSize(10, 3)
  newInstance:setZ(5)
  return newInstance
end

function Image:render()
  VisualObject.render(self)
end

function Image:load(path)

end

return Image