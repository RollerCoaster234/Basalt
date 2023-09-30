local objectLoader = require("objectLoader")
local Object = objectLoader.load("Object")
local VisualObject = objectLoader.load("VisualObject")
local getCenteredPosition = require("utils").getCenteredPosition


local Button = setmetatable({}, VisualObject)

Object:initialize("Button")
Object:addProperty("text", "string", "Button")

function Button:new()
  local newInstance = VisualObject:new()
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:setType("Button")
  newInstance:create("Button")
  newInstance:setSize(10, 3)
  newInstance:setZ(5)
  return newInstance
end

function Button:render()
  VisualObject.render(self)
  local text = self:getText()
  local xO, yO = getCenteredPosition(text, self:getWidth(), self:getHeight())
  self:addText(xO, yO, text)
end

return Button