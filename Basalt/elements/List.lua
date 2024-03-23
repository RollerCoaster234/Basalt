local loader = require("basaltLoader")
local Element = loader.load("BasicElement")
local VisualElement = loader.load("VisualElement")
local tHex = require("tHex")

---@class List : ListL
local List = setmetatable({}, VisualElement)

Element:initialize("List")
Element:addProperty("items", "table", {})
Element:addProperty("itemsBackground", "table", {})
Element:addProperty("itemsForeground", "table", {})
Element:addProperty("selection", "boolean", true)
Element:addProperty("multiSelection", "boolean", false)
Element:addProperty("autoScroll", "boolean", false)
Element:addProperty("selectedIndex", "table", {1}, nil, function(self, value)
  local newValue = self.selectedIndex
  if(self:getMultiSelection())then
    if(type(value)=="table")then
      newValue = value
    else
      if(self:getSelectionState(value))then
        for i, v in ipairs(newValue) do
          if v == value then
            table.remove(newValue, i)
            return newValue
          end
        end
      else
        table.insert(newValue, value)
      end
    end
    return newValue
  else
    return {value}
  end
end, function(self, value, index)
  if(self:getMultiSelection())then
    return value
  else
    return value[1]
  end
end)
Element:addProperty("selectionBackground", "color", colors.black)
Element:addProperty("selectionForeground", "color", colors.cyan)
Element:combineProperty("selectionColor", "selectionBackground", "selectionForeground")
Element:addProperty("scrollIndex", "number", 1)

Element:addListener("change", "changed_value")

--- Creates a new List.
---@param id string The id of the object.
---@param parent? Container The parent of the object.
---@param basalt Basalt The basalt object.
--- @return List
---@protected
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

---@protected
function List:render()
  VisualElement.render(self)
  local w, h = self:getSize()
  local items = self:getItems()
  local itemsBg = self:getItemsBackground()
  local itemsFg = self:getItemsForeground()
  local scrollIndex = self:getScrollIndex()
  local selectedIndex = self:getSelectedIndex()
  local selectionBg, selectionFg = self:getSelectionColor()
  local selection = self:getSelection()

  for i = 1, h do
    local index = i + scrollIndex - 1
    local item = items[index]
    if item then
      self:addText(1, i, item)
      if(itemsBg[index])then
        self:addBg(1, i, tHex[itemsBg[index]]:rep(w))
      end
      if(itemsFg[index])then
        self:addFg(1, i, tHex[itemsFg[index]]:rep(w))
      end
      if(selection)then
        if self:getSelectionState(index) then
          self:addBg(1, i, tHex[selectionBg]:rep(w))
          self:addFg(1, i, tHex[selectionFg]:rep(w))
        end
      end
    end
  end
end

--- Returns the selection state of the item at the given index.
---@param self List The element itself
---@param index number The index of the item.
---@return boolean
function List:getSelectionState(index)
  if(self:getMultiSelection())then
    local selectedIndex = self:getSelectedIndex()
    for i, v in ipairs(selectedIndex) do
        if v == index then
            return true
        end
    end
  else
    if(self:getSelectedIndex() == index)then
      return true
    end
  end
    return false
end

--- Adds an item to the list.
---@param self List The element itself
---@param item string The item to add.
---@param bg? integer The background color of the item.
---@param fg? integer The foreground color of the item.
function List:addItem(item, bg, fg)
    table.insert(self.items, item)
    if(bg~=nil)then
      table.insert(self.itemsBackground, bg or self:getBackground())
    end
    if(fg~=nil)then
      table.insert(self.itemsForeground, fg or self:getForeground())
    end
    if(self:getAutoScroll())then
      if(#self:getItems() > self:getHeight())then
        self:setScrollIndex(#self:getItems() - self:getHeight() + 1)
      end
    end
    self:updateRender()
    return self
end

--- Updates the color of the item at the given index.
---@param self List The element itself
---@param index number The index of the item.
---@param bg? integer The background color of the item.
---@param fg? integer The foreground color of the item.
function List:updateColor(index, bg, fg)
    self.itemsBackground[index] = bg or self:getBackground()
    self.itemsForeground[index] = fg or self:getForeground()
    self:updateRender()
    return self
end

--- Removes the item from the list.
---@param self List The element itself
---@param item string The item to remove.
---@return List
function List:removeItem(item)
    for i, v in ipairs(self.items) do
        if v == item then
            table.remove(self.items, i)
            table.remove(self.itemsBackground, i)
            table.remove(self.itemsForeground, i)
            if(self:getAutoScroll())then
                if(#self:getItems() > self:getHeight())then
                    self:setScrollIndex(#self:getItems() - self:getHeight() + 1)
                end
            end
            self:updateRender()
            return self
        end
    end
    return self
end

--- Removes the item from the list by its index.
---@param self List The element itself
---@param index number The index of the item.
---@return List
function List:removeItemByIndex(index)
    table.remove(self.items, index)
    self:updateRender()
    return self
end

--- Clears the list.
---@param self List The element itself
---@return List
function List:clear()
    self.items = {}
    self:updateRender()
    return self
end

--- Selects the item.
---@param self List The element itself
---@param item string The item to select.
---@return List
function List:selectItem(item)
    for i, v in ipairs(self:getItems()) do
        if v == item then
            self:setSelectedIndex(i)
            self:fireEvent("change", v)
            return self
        end
    end
    self:updateRender()
    return self
end

--- Selects the item by its index.
---@param self List The element itself
---@param index number The index of the item.
---@return List
function List:selectItemByIndex(index)
    self:setSelectedIndex(index)
    self:fireEvent("change", self:getItems()[index])
    return self
end

--- Returns all selected items.
---@param self List The element itself
---@return table
function List:getSelectedItems()
  if(self:getMultiSelection())then
    local items = self:getItems()
    local selectedItems = {}
    for i, v in ipairs(self:getSelectedIndex()) do
        table.insert(selectedItems, items[v])
    end
    return selectedItems
  else
    return self:getItems()[self:getSelectedIndex()]
  end
end

---@protected
function List:mouse_click(button, x, y)
    if(VisualElement.mouse_click(self, button, x, y)) then
      if(button == 1) then
        local xPos, yPos = self:getPosition()
        local scrollIndex = self:getScrollIndex()
        local items = self:getItems()
        local selectedIndex = self:getSelectedIndex()
        local clickedIndex = y - yPos + scrollIndex
        if clickedIndex >= 1 and clickedIndex <= #items then
          self:setSelectedIndex(clickedIndex)
          self:fireEvent("change", self:getSelectedItems())
        end
      end
      return true
    end
  end

  ---@protected
function List:mouse_scroll(direction, x, y)
  if(VisualElement.mouse_scroll(self, direction, x, y)) then
    local xPos, yPos = self:getPosition()
    local w, h = self:getSize()
    local scrollIndex = self:getScrollIndex()
    local items = self:getItems()
    local selectedIndex = self:getSelectedIndex()
    if direction == 1 and scrollIndex < #items - h + 1 then
      scrollIndex = scrollIndex + 1
    elseif direction == -1 and scrollIndex > 1 then
      scrollIndex = scrollIndex - 1
    end
    self:setScrollIndex(scrollIndex)
    self:updateRender()
    return true
  end
end

return List