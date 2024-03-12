local loader = require("basaltLoader")
local Element = loader.load("BasicElement")
local VisualElement = loader.load("VisualElement")
local getCenteredPosition = require("utils").getCenteredPosition


local Button = setmetatable({}, VisualElement)

Element:initialize("Button")
Element:addProperty("text", "string", "Button")

function Button:new(id, parent, basalt)
  local newInstance = VisualElement:new(id, parent, basalt)
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:setType("Button")
  newInstance:create("Button")
  newInstance:setSize(10, 3)
  newInstance:setZ(5)
  return newInstance
end

function Button:render()
  VisualElement.render(self)
  local text = self:getText()
  local xO, yO = getCenteredPosition(text, self:getWidth(), self:getHeight())
  self:addText(xO, yO, text)
end

return Button