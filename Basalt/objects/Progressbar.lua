local VisualObject = require("objectLoader").load("VisualObject")

local Progressbar = VisualObject:new()

Progressbar:initialize("Progressbar")
Progressbar:addProperty("progress", "number", 0)
Progressbar:addProperty("progressBackground", "color", colors.cyan)
Progressbar:addProperty("minValue", "number", 0)
Progressbar:addProperty("maxValue", "number", 100)

function Progressbar:new()
  local newInstance = setmetatable({}, self)
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