local VisualObject = require("objectLoader").load("VisualObject")

local Checkbox = VisualObject:new()

Checkbox:initialize("Checkbox")
Checkbox:addProperty("checked", "boolean", false)
Checkbox:addProperty("checkedSymbol", "string", "\42")
Checkbox:addProperty("checkedColor", "color", colors.white)
Checkbox:addProperty("checkedBgColor", "color", colors.black)
Checkbox:combineProperty("Symbol", "checkedSymbol", "checkedColor", "checkedBgColor")

Checkbox:addListener("check", "checked_value")

function Checkbox:new()
  local newInstance = setmetatable({}, self)
  self.__index = self
  newInstance:setType("Checkbox")
  newInstance:create("Checkbox")
  newInstance:setSize(1, 1)
  return newInstance
end

function Checkbox:render()
    VisualObject.render(self)
    if self.checked then
        self:addText(1, 1, self.checkedSymbol)
    else
        self:addText(1, 1, " ")
    end
end

Checkbox:extend("Load", function(self)
    self:listenEvent("mouse_click")
end)

function Checkbox:mouse_click(button, x, y)
    if(VisualObject.mouse_click(self, button, x, y))then
        if(button == 1)then
            self.checked = not self.checked
            self:fireEvent("check", self.checked)
            self:updateRender()
        end
        return true
    end
end

return Checkbox