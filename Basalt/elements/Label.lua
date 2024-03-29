local loader = require("basaltLoader")
local VisualElement = loader.load("VisualElement")
local splitString = require("utils").splitString

---@class Label : VisualElement
local Label = setmetatable({}, VisualElement)
Label.__index = Label
local sub, rep = string.sub, string.rep

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
                    local line = sub(v, 1, last_space - 1)
                    
                    table.insert(result, line)
                    v = sub(v, last_space)
                else
                    local line = sub(v, 1, last_space - 1)
                    if(line:sub(1,1)==" ")then
                        line = line:sub(2, #line)
                    end
                    table.insert(result, line)
                    v = sub(v, last_space + 1)
                end

                if #v <= width then
                    break
                end
            end
            if #v > 0 then
                if(v:sub(1,1)==" ")then
                    v = v:sub(2, #v)
                end
                table.insert(result, v)
            end
        end
    end
    return result
end

Label:initialize("Label")
Label:addProperty("autoSize", "boolean", true)
Label:addProperty("wrap", "boolean", false)
Label:addProperty("wrappedText", "table", {}, nil, function(self, value)
    self:setWrap(true)
end)
Label:addProperty("Coloring", "boolean", false)
Label:addProperty("text", "string", "My Label", nil, function(self, value)
    if(self.autoSize)and not(self.wrap)then
        self:setSize(value:len(), 1)
    elseif(self.autoSize)and(self.wrap)then
        local lines = wrapText(value, self:getWidth())
        self:setWrappedText(lines)
        self:setHeight(#lines)
    end
end)

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

---@protected
Label:extend("Init", function(self)
    self:setBackground(self.parent:getBackground())
    self:setForeground(self.parent:getForeground())

    self:addPropertyObserver("width", function()
        if(self.autoSize)and(self.wrap)then
            local lines = wrapText(self:getText(), self:getWidth())
            self:setWrappedText(lines)
            self:setHeight(#lines)
        end
    end)
end)

---@protected
function Label:render()
    VisualElement.render(self)
    local text = self:getText()
    local wrap = self:getWrap()
    local w, h = self:getSize()
    if(wrap)then
        local lines = self:getWrappedText()
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