local objectLoader = require("objectLoader")
local Object = objectLoader.load("Object")
local VisualObject = objectLoader.load("VisualObject")
local List = objectLoader.load("List")
local Dropdown = setmetatable({}, List)
local tHex = require("tHex")

Object:initialize("Dropdown")
Object:addProperty("opened", "boolean", false)
Object:addProperty("dropdownHeight", "number", 5)
Object:addProperty("dropdownWidth", "number", 15)
Object:combineProperty("dropdownSize", "dropdownWidth", "dropdownHeight")

function Dropdown:new()
    local newInstance = List:new()
    setmetatable(newInstance, self)
    self.__index = self
    newInstance:setType("Dropdown")
    newInstance:create("Dropdown")
    newInstance:setSize(10, 1)
    newInstance:setZ(7)
    return newInstance
end

function Dropdown:render()
    VisualObject.render(self)
    local selectedIndex = self:getSelectedIndex()
    local scrollIndex = self:getScrollIndex()
    if self.items[selectedIndex] then
        self:addText(1, 1, self.items[selectedIndex])
        self:addText(self:getWidth(), 1, "\16")
    end
    if self.opened then
        self:addText(self:getWidth(), 1, "\31")
        for i = 1, self.dropdownHeight do
            local item = self.items[i + scrollIndex - 1]
            if item then
                self:addText(1, i+1, item..(" "):rep(self.dropdownWidth - item:len()))
                if(i + scrollIndex - 1 == selectedIndex) then
                    self:addBg(1, i+1, tHex[self.selectionBackground]:rep(self.dropdownWidth))
                    self:addFg(1, i+1, tHex[self.selectionForeground]:rep(self.dropdownWidth))
                else
                    self:addBg(1, i+1, tHex[self.background]:rep(self.dropdownWidth))
                    self:addFg(1, i+1, tHex[self.foreground]:rep(self.dropdownWidth))
                end
            end
        end
    end
end

function Dropdown:mouse_click(button, x, y)
    if(VisualObject.mouse_click(self, button, x, y)) then
        self.opened = not self.opened
        return true
    end
    if self.opened then
        if(x >= self.x and x <= self.x + self.dropdownWidth and y >= self.y + 1 and y <= self.y + self.dropdownHeight) then
            self.selectedIndex = y - self.y + self.scrollIndex - 1
            self.opened = false
            self:fireEvent("change", self.items[self.selectedIndex])
            self:updateRender()
            return true
        end
    end
end

function Dropdown:mouse_scroll(direction, x, y)
    if(VisualObject.mouse_scroll(self, direction, x, y)) then
        self.selectedIndex = math.max(math.min(self.selectedIndex + direction, #self.items), 1)
        self:updateRender()
    end
    if self:getOpened() then
        if(x >= self.x and x <= self.x + self.dropdownWidth and y >= self.y + 1 and y <= self.y + self.dropdownHeight) then
            if direction == -1 then
                self.scrollIndex = math.max(self.scrollIndex - 1, 1)
            else
                self.scrollIndex = math.min(self.scrollIndex + 1, #self.items - self.dropdownHeight + 1)
            end
            self:updateRender()
        end
    end
end

return Dropdown