local VisualObject = require("objectLoader").load("VisualObject")

local Label = VisualObject:new()

Label:initialize("Label")
Label:addProperty("autoSize", "boolean", true)
Label:addProperty("text", "string", "My Label", nil, function(self, value)
    if(self.autoSize)then
        self:setSize(value:len(), 1)
    end
end)

function Label:new()
  local newInstance = setmetatable({}, self)
  self.__index = self
  newInstance:setType("Label")
  newInstance:create("Label")
  newInstance:setSize(8, 1)
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