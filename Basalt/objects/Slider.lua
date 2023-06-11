local VisualObject = require("objectLoader").load("VisualObject")
local tHex = require("tHex")

local Slider = VisualObject:new()

Slider:initialize("Slider")
Slider:addProperty("knobSymbol", "string", "#")
Slider:addProperty("knobBackground", "color", colors.black)
Slider:addProperty("knobForeground", "color", colors.black)
Slider:addProperty("bgSymbol", "string", "\140")
Slider:addProperty("value", "number", 0)
Slider:addProperty("minValue", "number", 0)
Slider:addProperty("maxValue", "number", 100)
Slider:addProperty("step", "number", 1)

Slider:addListener("change", "value_change")

function Slider:new()
  local newInstance = setmetatable({}, self)
  self.__index = self
  newInstance:setType("Slider")
  newInstance:create("Slider")
  newInstance:setSize(20, 1)
  return newInstance
end

Slider:extend("Init", function(self)
    self:setBackground(self.parent.background)
end)

Slider:extend("Load", function(self)
    self:listenEvent("mouse_click")
    self:listenEvent("mouse_drag")
    self:listenEvent("mouse_up")
    self:listenEvent("mouse_scroll")
end)

local function calculateKnobPosition(self, x, y)
    local relativeX = x - self.x
    self.value = relativeX / (self.width - 1) * (self.maxValue - self.minValue) + self.minValue
    self.value = math.floor((self.value + self.step / 2) / self.step) * self.step
    self.value = math.max(self.minValue, math.min(self.maxValue, self.value))
    self:fireEvent("value_change", self.value)
    self:updateRender()
end

function Slider:mouse_click(button, x, y)
    if(VisualObject.mouse_click(self, button, x, y))then
        if(button == 1)then
            calculateKnobPosition(self, x, y)
        end
        return true
    end
end

function Slider:mouse_drag(button, x, y)
    if(VisualObject.mouse_drag(self, button, x, y))then
        if(button == 1)then
            calculateKnobPosition(self, x, y)
        end
        return true
    end
end

function Slider:mouse_scroll(direction, x, y)
    if(VisualObject.mouse_scroll(self, direction, x, y))then
        self.value = self.value + self.step * direction
        self.value = math.max(self.minValue, math.min(self.maxValue, self.value))
        self:fireEvent("value_change", self.value)
        self:updateRender()
        return true
    end
end

function Slider:render()
    VisualObject.render(self)
    local bar = (self.bgSymbol):rep(self.width)
    local knobPosition = math.floor((self.value - self.minValue) / (self.maxValue - self.minValue) * (self.width - 1) + 0.5)
    bar = bar:sub(1, knobPosition) .. self.knobSymbol .. bar:sub(knobPosition + 2, -1)
    self:addText(1, 1, bar)
    self:addBg(knobPosition + 1, 1, tHex[self.knobBackground])
    self:addFg(knobPosition + 1, 1, tHex[self.knobForeground])
end

return Slider