local loader = require("basaltLoader")
local Element = loader.load("BasicElement")
local VisualElement = loader.load("VisualElement")

local Label = setmetatable({}, VisualElement)

Element:initialize("Label")
Element:addProperty("autoSize", "boolean", true)
Element:addProperty("text", "string", "My Label", nil, function(self, value)
    if(self.autoSize)then
        self:setSize(value:len(), 1)
    end
end)

function Label:new(id, parent, basalt)
    local newInstance = VisualElement:new(id, parent, basalt)
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
    VisualElement.render(self)
    self:addText(1, 1, self.text)
end

return Label