local VisualObject = require("objectLoader").load("VisualObject")

local Input = VisualObject.new(VisualObject)

Input:setPropertyType("Input")

Input:addProperty("value", "string", "")
Input:addProperty("cursorIndex", "number", 1)
Input:addProperty("scrollIndex", "number", 1)
Input:addProperty("inputLimit", "number", nil)
Input:addProperty("inputType", "string", "text")

function Input:new()
  local newInstance = setmetatable({}, self)
  self.__index = self
  newInstance:setType("Input")
  newInstance:addDefaultProperties("Input")
  newInstance:setSize(10, 1)
  return newInstance
end

Input:extend("Init", function(self)
    self:setRenderData(function(self)
        local visibleValue = self.value:sub(self.scrollIndex, self.scrollIndex + self.width - 1)
        if(self.inputType=="password")then
            visibleValue = ("*"):rep(visibleValue:len())
        end
        local space = (" "):rep(self.width - visibleValue:len()-1)
        visibleValue = visibleValue .. space
        self:addText(1, 1, visibleValue)
    end)
end)

Input:extend("Load", function(self)
    self:listenEvent("mouse_click")
end)

function Input:lose_focus()
    self.parent:setCursor(false)
end

function Input:mouse_click(button, x, y)
    if(VisualObject.mouse_click(self, button, x, y))then
        if(button == 1)then
            self.cursorIndex = math.min(x - self.x + self.scrollIndex, self.value:len() + 1)
            self.parent:setCursor(true, self.x + self.cursorIndex - 1, self.y, self.foreground)
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
        elseif key == keys.left then
            self.cursorIndex = math.max(1, self.cursorIndex - 1)
        elseif key == keys.right then
            self.cursorIndex = math.min(self.value:len() + 1, self.cursorIndex + 1)
        elseif key == keys.enter then
            self:setFocused(false)
            self:adjustScrollIndex()
            return
        end
        self:adjustScrollIndex()
        self.parent:setCursor(true, self.x + self.cursorIndex - 1, self.y, self.foreground)
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
        self:adjustScrollIndex()
        self.parent:setCursor(true, self.x + self.cursorIndex - 1, self.y, self.foreground)
        return true
    end
end

function Input:adjustScrollIndex()
    if self.cursorIndex < self.scrollIndex then
        self.scrollIndex = self.cursorIndex
    elseif self.cursorIndex > self.scrollIndex + self.width then
        self.scrollIndex = self.cursorIndex - self.width
    end
end

return Input