local loader = require("basaltLoader")
local Element = loader.load("BasicElement")
local VisualElement = loader.load("VisualElement")
local tHex = require("tHex")

---@class Slider : VisualElement
local Slider = setmetatable({}, VisualElement)

Element:initialize("Slider")
Element:addProperty("knobSymbol", "string", " ")
Element:addProperty("knobBackground", "color", colors.black)
Element:addProperty("knobForeground", "color", colors.black)
Element:addProperty("bgSymbol", "string", "\140")
Element:addProperty("value", "number", 0)
Element:addProperty("minValue", "number", 0)
Element:addProperty("maxValue", "number", 100)
Element:addProperty("step", "number", 1)

Element:combineProperty("knob", "knobSymbol", "knobBackground", "knobForeground")

Slider:addListener("change", "value_change")

--- Creates a new Slider.
---@param id string The id of the object.
---@param parent? Container The parent of the object.
---@param basalt Basalt The basalt object.
--- @return Slider
---@protected
function Slider:new(id, parent, basalt)
  local newInstance = VisualElement:new(id, parent, basalt)
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:setType("Slider")
  newInstance:create("Slider")
  newInstance:setSize(20, 1)
  return newInstance
end

Slider:extend("Load", function(self)
    self:listenEvent("mouse_click")
    self:listenEvent("mouse_drag")
    self:listenEvent("mouse_up")
    self:listenEvent("mouse_scroll")
end)

---@protected
local function calculateKnobPosition(self, x, y)
    local relativeX = x - self.x
    self.value = relativeX / (self.width - 1) * (self.maxValue - self.minValue) + self.minValue
    self.value = math.floor((self.value + self.step / 2) / self.step) * self.step
    self.value = math.max(self.minValue, math.min(self.maxValue, self.value))
    self:fireEvent("value_change", self.value)
    self:updateRender()
end

---@protected
function Slider:mouse_click(button, x, y)
    if(VisualElement.mouse_click(self, button, x, y))then
        if(button == 1)then
            calculateKnobPosition(self, x, y)
        end
        return true
    end
end

---@protected
function Slider:mouse_drag(button, x, y)
    if(VisualElement.mouse_drag(self, button, x, y))then
        if(button == 1)then
            calculateKnobPosition(self, x, y)
        end
        return true
    end
end

---@protected
function Slider:mouse_scroll(direction, x, y)
    if(VisualElement.mouse_scroll(self, direction, x, y))then
        self.value = self.value + direction * (self.maxValue / self.width)
        self.value = math.max(self.minValue, math.min(self.maxValue, self.value))
        self:fireEvent("value_change", self.value)
        self:updateRender()
        return true
    end
end

---@protected
function Slider:render()
    VisualElement.render(self)
    local bar = (self.bgSymbol):rep(self.width)
    local knobPosition = math.floor((self.value - self.minValue) / (self.maxValue - self.minValue) * (self.width - 1) + 0.5)
    bar = bar:sub(1, knobPosition) .. self.knobSymbol .. bar:sub(knobPosition + 2, -1)
    self:addText(1, 1, bar)
    self:addBg(knobPosition + 1, 1, tHex[self:getKnobBackground()])
    self:addFg(knobPosition + 1, 1, tHex[self:getKnobForeground()])
end

return Slider