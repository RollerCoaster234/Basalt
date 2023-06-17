local objectLoader = require("objectLoader")
local Object = objectLoader.load("Object")
local VisualObject = objectLoader.load("VisualObject")

local TextField = setmetatable({}, VisualObject)

Object:initialize("TextField")
Object:addProperty("lines", "table", {""})
Object:addProperty("lineIndex", "number", 1)
Object:addProperty("scrollIndexX", "number", 1)
Object:addProperty("scrollIndexY", "number", 1)
Object:addProperty("cursorIndex", "number", 1)


function TextField:new()
  local newInstance = VisualObject:new()
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:setType("TextField")
  newInstance:create("TextField")
  newInstance:setSize(10, 5)
  return newInstance
end

TextField:extend("Load", function(self)
    self:listenEvent("mouse_click")
    self:listenEvent("mouse_scroll")
end)

function TextField:render()
    VisualObject.render(self)
    for i = 1, self.height do
      local visibleLine = ""
      if self.lines[i+self.scrollIndexY-1] ~= nil then
        local line = self.lines[i+self.scrollIndexY-1]
        visibleLine = line:sub(self.scrollIndexX, self.scrollIndexX + self.width - 1)
      end
      local space = (" "):rep(self.width - visibleLine:len())
      visibleLine = visibleLine .. space
      self:addText(1, i, visibleLine)
    end
  end

  function TextField:adjustScrollIndices(updateAccordingToCursor)
    if updateAccordingToCursor then
      -- Adjust according to cursor position
      if self.cursorIndex < self.scrollIndexX then
        self.scrollIndexX = self.cursorIndex
      elseif self.cursorIndex >= self.scrollIndexX + self.width then
        self.scrollIndexX = self.cursorIndex - self.width + 1
      end
      if self.lineIndex < self.scrollIndexY then
        self.scrollIndexY = self.lineIndex
      elseif self.lineIndex >= self.scrollIndexY + self.height then
        self.scrollIndexY = self.lineIndex - self.height + 1
      end
    end
    -- Ensure scroll indices are within valid range
    self.scrollIndexX = math.max(1, self.scrollIndexX)
    self.scrollIndexY = math.max(1, self.scrollIndexY)
  end

  function TextField:updateCursor()
    if self.cursorIndex >= self.scrollIndexX and self.cursorIndex < self.scrollIndexX + self.width
       and self.lineIndex >= self.scrollIndexY and self.lineIndex < self.scrollIndexY + self.height then
      self.parent:setCursor(true, self.x + self.cursorIndex - self.scrollIndexX, self.y + self.lineIndex - self.scrollIndexY, self:getForeground())
    else
      self.parent:setCursor(false)
    end
  end

function TextField:mouse_click(button, x, y)
    if(VisualObject.mouse_click(self, button, x, y)) then
      if(button == 1) then
          if(#self.lines > 0)then
              self.lineIndex = math.min(y - self.y + self.scrollIndexY, #self.lines)
              self.cursorIndex = math.min(x - self.x + self.scrollIndexX, self.lines[self.lineIndex]:len() + 1)
              self:adjustScrollIndices(true)
          else
              self.lineIndex = 1
              self.cursorIndex = 1
          end
          self:updateCursor()
      end
      return true
    end
  end

  function TextField:mouse_scroll(direction, x, y)
    if (VisualObject.mouse_scroll(self, direction, x, y)) then
      -- Scrolling down
      if direction == 1 then
        self.scrollIndexY = math.min(#self.lines - self.height + 1, self.scrollIndexY + 1)
      -- Scrolling up
      elseif direction == -1 then
        self.scrollIndexY = math.max(1, self.scrollIndexY - 1)
      end
      self:adjustScrollIndices(false)  -- Update scroll indices without focusing the cursor
      self:updateCursor()
      self:updateRender()
      return true
    end
  end  

function TextField:key(key)
    if(VisualObject.key(self, key)) then
      local line = self.lines[self.lineIndex]
      if key == keys.enter then
        local before = line:sub(1, self.cursorIndex-1)
        local after = line:sub(self.cursorIndex, -1)
        self.lines[self.lineIndex] = before
        table.insert(self.lines, self.lineIndex + 1, after)
        self.lineIndex = self.lineIndex + 1
        self.cursorIndex = 1
      elseif key == keys.backspace then
        if line ~= "" and self.cursorIndex > 1 then
          local before = line:sub(1, self.cursorIndex-2)
          local after = line:sub(self.cursorIndex, -1)
          self.lines[self.lineIndex] = before .. after
          self.cursorIndex = self.cursorIndex - 1
        elseif line == "" and self.lineIndex > 1 then
          table.remove(self.lines, self.lineIndex)
          self.lineIndex = self.lineIndex - 1
          self.cursorIndex = self.lines[self.lineIndex]:len() + 1
        elseif self.cursorIndex == 1 and self.lineIndex > 1 then
          self.cursorIndex = self.lines[self.lineIndex - 1]:len() + 1
          self.lines[self.lineIndex - 1] = self.lines[self.lineIndex - 1] .. self.lines[self.lineIndex]
          table.remove(self.lines, self.lineIndex)
          self.lineIndex = self.lineIndex - 1
        end
      elseif key == keys.delete then
        if line ~= "" and self.cursorIndex <= line:len() then
          local before = line:sub(1, self.cursorIndex-1)
          local after = line:sub(self.cursorIndex+1, -1)
          self.lines[self.lineIndex] = before .. after
        elseif line == "" and self.lineIndex < #self.lines then
          table.remove(self.lines, self.lineIndex)
        elseif self.cursorIndex == line:len() + 1 and self.lineIndex < #self.lines then
          self.lines[self.lineIndex] = self.lines[self.lineIndex] .. self.lines[self.lineIndex + 1]
          table.remove(self.lines, self.lineIndex + 1)
        end
      elseif key == keys.up and self.lineIndex > 1 then
        self.lineIndex = self.lineIndex - 1
        self.cursorIndex = math.min(self.cursorIndex, self.lines[self.lineIndex]:len() + 1)
      elseif key == keys.down and self.lineIndex < #self.lines then
        self.lineIndex = self.lineIndex + 1
        self.cursorIndex = math.min(self.cursorIndex, self.lines[self.lineIndex]:len() + 1)
      elseif key == keys.left then
        self.cursorIndex = math.max(1, self.cursorIndex - 1)
      elseif key == keys.right then
        self.cursorIndex = math.min(line:len() + 1, self.cursorIndex + 1)
      end
      self:adjustScrollIndices(true)
      self:updateCursor()
      self:updateRender()
      return true
    end
  end



function TextField:char(char)
  if(VisualObject.char(self, char))then
    local line = self.lines[self.lineIndex]
    local before = line:sub(1, self.cursorIndex-1)
    local after = line:sub(self.cursorIndex, -1)
    self.lines[self.lineIndex] = before .. char .. after
    self.cursorIndex = self.cursorIndex + 1
    self:adjustScrollIndices(true)
    self:updateCursor()
    self:updateRender()
    return true
  end
end

return TextField
