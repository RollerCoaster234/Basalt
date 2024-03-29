local loader = require("basaltLoader")
local VisualElement = loader.load("VisualElement")


local Image = setmetatable({}, VisualElement)
Image.__index = Image

Image:initialize("Image")

function Image:new(id, parent, basalt)
  local newInstance = VisualElement:new(id, parent, basalt)
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:setType("Image")
  newInstance:create("Image")
  newInstance:setSize(10, 3)
  newInstance:setZ(5)
  return newInstance
end

function Image:render()
  VisualElement.render(self)
end

function Image:load(path)

end

return Image