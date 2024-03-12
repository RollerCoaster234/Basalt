local loader = require("basaltLoader")
local Element = loader.load("BasicElement")
local VisualElement = loader.load("VisualElement")
local tHex = require("tHex")

local List = setmetatable({}, VisualElement)

Element:initialize("List")
Element:addProperty("items", "table", {}) -- now each item is a ListItem object
Element:addProperty("selectedIndex", "number", 1)
Element:addProperty("selectionBackground", "color", colors.black)
Element:addProperty("selectionForeground", "color", colors.cyan)
Element:combineProperty("selectionColor", "selectionBackground", "selectionForeground")
Element:addProperty("scrollIndex", "number", 1)

Element:addListener("change", "changed_value")

function List:new(id, parent, basalt)
  local newInstance = VisualElement:new(id, parent, basalt)
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:setType("List")
  newInstance:create("List")
  newInstance:setSize(15, 6)
  return newInstance
end

List:extend("Load", function(self)
    self:listenEvent("mouse_click")
    self:listenEvent("mouse_scroll")
end)

function List:render()
  VisualElement.render(self)
  for i = 1, self.height do
    local item = self.items[i + self.scrollIndex - 1]
    if item then
      self:addText(1, i, item)
      if(i + self.scrollIndex - 1 == self.selectedIndex) then
        self:addBg(1, i, tHex[self.selectionBackground]:rep(self.width))
        self:addFg(1, i, tHex[self.selectionForeground]:rep(self.width))
      end
    end
  end
end

function List:addItem(item)
    table.insert(self.items, item)
    return self
end

function List:removeItem(item)
    for i, v in ipairs(self.items) do
        if v == item then
            table.remove(self.items, i)
            return self
        end
    end
end

function List:removeItemByIndex(index)
    table.remove(self.items, index)
    return self
end

function List:clear()
    self.items = {}
    return self
end

function List:selectItem(item)
    for i, v in ipairs(self.items) do
        if v == item then
            self.selectedIndex = i
            self:fireEvent("change", v)
            return self
        end
    end
end

function List:selectItemByIndex(index)
    self.selectedIndex = index
    self:fireEvent("change", self.items[index])
    return self
end

function List:getSelectedItem()
    return self.items[self.selectedIndex]
end

function List:getSelectedIndex()
    return self.selectedIndex
end

function List:mouse_click(button, x, y)
    if(VisualElement.mouse_click(self, button, x, y)) then
      if(button == 1) then
        local clickedIndex = y - self.y + self.scrollIndex
        if clickedIndex >= 1 and clickedIndex <= #self.items then
          self.selectedIndex = clickedIndex
          self:fireEvent("change", self.items[clickedIndex])
        end
      end
      return true
    end
  end

function List:mouse_scroll(direction, x, y)
  if(VisualElement.mouse_scroll(self, direction, x, y)) then
    if direction == 1 and self.scrollIndex < #self.items - self.height + 1 then
      self.scrollIndex = self.scrollIndex + 1
    elseif direction == -1 and self.scrollIndex > 1 then
      self.scrollIndex = self.scrollIndex - 1
    end
    self:updateRender()
    return true
  end
end

return List