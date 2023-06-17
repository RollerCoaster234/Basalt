local objectLoader = require("objectLoader")
local Object = objectLoader.load("Object")
local VisualObject = objectLoader.load("VisualObject")

local Label = setmetatable({}, VisualObject)

Object:initialize("Label")
Object:addProperty("autoSize", "boolean", true)
Object:addProperty("text", "string", "My Label", nil, function(self, value)
    if(self.autoSize)then
        self:setSize(value:len(), 1)
    end
end)

function Label:new()
    local newInstance = VisualObject:new()
    setmetatable(newInstance, self)
    self.__index = self
    newInstance:setType("Label")
    newInstance:create("Label")
  return newInstance
end

Label:extend("Init", function(self)
    self:setBackground(self.parent.background)
    self:setForeground(self.parent.foreground)
end)

function Label:render()
    VisualObject.render(self)
    self:addText(1, 1, self.text)
end

return Label