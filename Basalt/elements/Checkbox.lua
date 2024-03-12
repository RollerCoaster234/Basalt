local loader = require("basaltLoader")
local Element = loader.load("BasicElement")
local VisualElement = loader.load("VisualElement")
local getCenteredPosition = require("utils").getCenteredPosition

local Checkbox = setmetatable({}, VisualElement)

Element:initialize("Checkbox")
Element:addProperty("checked", "boolean", false)
Element:addProperty("checkedSymbol", "string", "\42")
Element:addProperty("checkedColor", "color", colors.white)
Element:addProperty("checkedBgColor", "color", colors.black)
Element:combineProperty("Symbol", "checkedSymbol", "checkedColor", "checkedBgColor")

Element:addListener("check", "checked_value")

function Checkbox:new(id, parent, basalt)
    local newInstance = VisualElement:new(id, parent, basalt)
    setmetatable(newInstance, self)
    self.__index = self
    newInstance:setType("Checkbox")
    newInstance:create("Checkbox")
    newInstance:setSize(1, 1)
  return newInstance
end

function Checkbox:render()
    VisualElement.render(self)
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
    if(VisualElement.mouse_click(self, button, x, y))then
        if(button == 1)then
            self.checked = not self.checked
            self:fireEvent("check", self.checked)
            self:updateRender()
        end
        return true
    end
end

return Checkbox