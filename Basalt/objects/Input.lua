local objectLoader = require("objectLoader")
local Object = objectLoader.load("Object")
local VisualObject = objectLoader.load("VisualObject")

local Input = setmetatable({}, VisualObject)

Object:initialize("Input")
Object:addProperty("value", "string", "")
Object:addProperty("cursorIndex", "number", 1)
Object:addProperty("scrollIndex", "number", 1)
Object:addProperty("inputLimit", "number", nil)
Object:addProperty("inputType", "string", "text")

Object:addListener("change", "change_value")
Object:addListener("enter", "enter_pressed")

function Input:new()
  local newInstance = VisualObject:new()
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:setType("Input")
  newInstance:create("Input")
  newInstance:setSize(10, 1)
  newInstance:setZ(5)
  return newInstance
end

function Input.render(self)
    VisualObject.render(self)
    local visibleValue = self.value:sub(self.scrollIndex, self.scrollIndex + self.width - 1)
    if(self.inputType=="password")then
        visibleValue = ("*"):rep(visibleValue:len())
    end
    local space = (" "):rep(self.width - visibleValue:len())
    visibleValue = visibleValue .. space
    self:addText(1, 1, visibleValue)
end

Input:extend("Load", function(self)
    self:listenEvent("mouse_click")
end)

function Input:lose_focus()
    VisualObject.lose_focus(self)
    self.parent:setCursor(false)
end

function Input:mouse_click(button, x, y)
    if(VisualObject.mouse_click(self, button, x, y))then
        if(button == 1)then
            self.cursorIndex = math.min(x - self.x + self.scrollIndex, self.value:len() + 1)
            self.parent:setCursor(true, self.x + self.cursorIndex - self.scrollIndex, self.y, self:getForeground())
        end
        return true
    end
end

function Input:key(key)
    if(VisualObject.key(self, key))then
        if key == keys.backspace and self.value ~= "" and self.cursorIndex > 1 then
            local before = self.value:sub(1, self.cursorIndex-2)
            local after = self.value:sub(self.cursorIndex, -1)
            self.value = before .. after
            self.cursorIndex = self.cursorIndex - 1
            self:updateRender()
        elseif key == keys.left then
            self.cursorIndex = math.max(1, self.cursorIndex - 1)
            self:updateRender()
        elseif key == keys.right then
            self.cursorIndex = math.min(self.value:len() + 1, self.cursorIndex + 1)
            self:updateRender()
        elseif key == keys.enter then
            self:fireEvent("enter", self.value)
            self:setFocused(false)
            self:adjustScrollIndex()
            self:updateRender()
            return
        end
        self:adjustScrollIndex()
        self.parent:setCursor(true, self.x + self.cursorIndex - self.scrollIndex, self.y, self:getForeground())
        return true
    end
end

function Input:char(char)
    if(VisualObject.char(self, char))then
        if self.inputLimit and self.value:len() >= self.inputLimit then
            return true
        end
        if self.inputType == "number" and not tonumber(char) then
            if (char == "," or char == ".") and self.value:find("[.,]") then
                return true
            elseif char ~= "," and char ~= "." then
                return true
            end
        end
        local before = self.value:sub(1, self.cursorIndex-1)
        local after = self.value:sub(self.cursorIndex, -1)
        self.value = before .. char .. after
        self.cursorIndex = self.cursorIndex + 1
        self:fireEvent("change", self.value)
        self:adjustScrollIndex()
        self:updateRender()
        self.parent:setCursor(true, self.x + self.cursorIndex - self.scrollIndex, self.y, self:getForeground())
        return true
    end
end

function Input:adjustScrollIndex()
    if self.cursorIndex < self.scrollIndex then
        self.scrollIndex = self.cursorIndex
    elseif self.cursorIndex > self.scrollIndex + self.width - 1 then
        self.scrollIndex = self.cursorIndex - self.width + 1
    end
end

return Input