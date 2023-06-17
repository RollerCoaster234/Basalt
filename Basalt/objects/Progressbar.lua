local objectLoader = require("objectLoader")
local Object = objectLoader.load("Object")
local VisualObject = objectLoader.load("VisualObject")

local Progressbar = setmetatable({}, VisualObject)

Object:initialize("Progressbar")
Object:addProperty("progress", "number", 0)
Object:addProperty("progressBackground", "color", colors.cyan)
Object:addProperty("minValue", "number", 0)
Object:addProperty("maxValue", "number", 100)

function Progressbar:new()
  local newInstance = VisualObject:new()
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:setType("Progressbar")
  newInstance:create("Progressbar")
  newInstance:setSize(20, 3)
  return newInstance
end

function Progressbar:render()
    VisualObject.render(self)
    local barLength = math.floor((self.width - 2) * (self.progress - self.minValue) / (self.maxValue - self.minValue))
    self:addBackgroundBox(1, 1, barLength, self.height, self.progressBackground)
end

return Progressbar