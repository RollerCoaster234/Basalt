local loader = require("basaltLoader")
local Element = loader.load("BasicElement")
local VisualElement = loader.load("VisualElement")
local splitString = require("utils").splitString

---@class Label : LabelP
local Label = setmetatable({}, VisualElement)
local sub, rep = string.sub, string.rep

Element:initialize("Label")
Element:addProperty("autoSize", "boolean", true, nil, function(self, value)
    self.wrap = false
end)
Element:addProperty("Wrap", "boolean", false, nil, function(self, value)
    self.autoSize = false
end)
Element:addProperty("Coloring", "boolean", false)
Element:addProperty("text", "string", "My Label", nil, function(self, value)
    if(self.autoSize)then
        print(value)
        self:setSize(value:len(), 1)
    end
end)

-- Wrapping Features:
local function removeTags(input)
    return input:gsub("{[^}]+}", "")
end

local function wrapText(str, width)
    str = removeTags(str)
    if(str=="")or(width==0)then
        return {""}
    end
    if(#str <= width)then
        return {str}
    end
    local uniqueLines = splitString(str, "\n")
    local result = {}
    for k, v in pairs(uniqueLines) do
        if #v == 0 then
            table.insert(result, "")
        else
            while #v > width do
                local last_space = width
                for i = width, 1, -1 do
                    if sub(v, i, i) == " " then
                        last_space = i
                        break
                    end
                end

                if last_space == width then
                    local line = sub(v, 1, last_space - 1) .. "-"
                    table.insert(result, line)
                    v = sub(v, last_space)
                else
                    local line = sub(v, 1, last_space - 1)
                    table.insert(result, line)
                    v = sub(v, last_space + 1)
                end

                if #v <= width then
                    break
                end
            end
            if #v > 0 then
                table.insert(result, v)
            end
        end
    end
    return result
end

--- Creates a new label.
---@param id string The id of the object.
---@param parent? Container The parent of the object.
---@param basalt Basalt The basalt object.
--- @return Label
---@protected
function Label:new(id, parent, basalt)
    local newInstance = VisualElement:new(id, parent, basalt)
    setmetatable(newInstance, self)
    self.__index = self
    newInstance:setType("Label")
    newInstance:create("Label")
  return newInstance
end

--- Returns the given text wrapped.
---@return table<string> wrapped The wrapped text.
function Label:getWrappedText()
    return wrapText(self:getText(), self:getWidth())
end

---@protected
Label:extend("Init", function(self)
    self:setBackground(self.parent.background)
    self:setForeground(self.parent.foreground)
end)

---@protected
function Label:render()
    VisualElement.render(self)
    local text = self:getText()
    local wrap = self:getWrap()
    local w, h = self:getSize()
    if(wrap)then
        local lines = wrapText(text, w)
        for i, line in ipairs(lines) do
            if(i <= h)then
                self:addText(1, i, line)
            end
        end
    else
        self:addText(1, 1, text)
    end
end

return Label