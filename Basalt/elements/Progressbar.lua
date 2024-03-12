local loader = require("basaltLoader")
local Element = loader.load("BasicElement")
local VisualElement = loader.load("VisualElement")

local Progressbar = setmetatable({}, VisualElement)

Element:initialize("Progressbar")
Element:addProperty("progress", "number", 0)
Element:addProperty("progressBackground", "color", colors.black)
Element:addProperty("minValue", "number", 0)
Element:addProperty("maxValue", "number", 100)

function Progressbar:new(id, parent, basalt)
  local newInstance = VisualElement:new(id, parent, basalt)
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:setType("Progressbar")
  newInstance:create("Progressbar")
  newInstance:setSize(20, 3)
  return newInstance
end

function Progressbar:render()
    VisualElement.render(self)
    local barLength = math.floor((self.width - 2) * (self.progress - self.minValue) / (self.maxValue - self.minValue))
    self:addBackgroundBox(1, 1, barLength, self.height, self.progressBackground)
end

return Progressbar