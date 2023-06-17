local objectLoader = require("objectLoader")
local Object = objectLoader.load("Object")
local VisualObject = objectLoader.load("VisualObject")
local getCenteredPosition = require("utils").getCenteredPosition

local Checkbox = setmetatable({}, VisualObject)

Object:initialize("Checkbox")
Object:addProperty("checked", "boolean", false)
Object:addProperty("checkedSymbol", "string", "\42")
Object:addProperty("checkedColor", "color", colors.white)
Object:addProperty("checkedBgColor", "color", colors.black)
Object:combineProperty("Symbol", "checkedSymbol", "checkedColor", "checkedBgColor")

Object:addListener("check", "checked_value")

function Checkbox:new()
    local newInstance = VisualObject:new()
    setmetatable(newInstance, self)
    self.__index = self
    newInstance:setType("Checkbox")
    newInstance:create("Checkbox")
    newInstance:setSize(1, 1)
  return newInstance
end

function Checkbox:render()
    VisualObject.render(self)
    local xO, yO = getCenteredPosition(self.checkedSymbol, self:getWidth(), self:getHeight())
    if self.checked then
        self:addText(xO, yO, self.checkedSymbol)
    else
        self:addText(xO, yO, " ")
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