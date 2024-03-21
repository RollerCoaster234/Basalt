local loader = require("basaltLoader")
local Container = require("basaltLoader").load("Container")
local Element = loader.load("BasicElement")
local log = require("log")
local uuid = require("utils").uuid

local Flexbox = setmetatable({}, Container)

Element:initialize("Flexbox")
Element:addProperty("flexDirection", "string", "row")
Element:addProperty("flexSpacing", "number", 1)
Element:addProperty("flexJustifyContent", "string", "flex-start")
Element:addProperty("flexWrap", "boolean", false)
Element:addProperty("flexCreateLayout", "boolean", false)

local lineBreakElement = {
  getHeight = function(self) return 0 end,
  getWidth = function(self) return 0 end,
  getZ = function(self) return 1 end,
  getPosition = function(self) return 0, 0 end,
  getSize = function(self) return 0, 0 end,
  isType = function(self) return false end,
  getType = function(self) return "lineBreak" end,
  getName = function(self) return uuid() end,
  setPosition = function(self) end,
  setParent = function(self) end,
  setSize = function(self) end,
  getFlexGrow = function(self) return 0 end,
  getFlexShrink = function(self) return 0 end,
  getFlexBasis = function(self) return 0 end,
  init = function(self) end,
  getVisible = function(self) return true end,
}


local function sortElements(self, direction, spacing, wrap)
    local elements = self:getChildren()
    local sortedElements = {}
    if not(wrap)then
      local index = 1
      local lineSize = 1
      local lineOffset = 1
      for _,v in pairs(elements)do
          if(sortedElements[index]==nil)then sortedElements[index]={offset=1} end

          local childHeight = direction == "row" and v:getHeight() or v:getWidth()
          if childHeight > lineSize then
              lineSize = childHeight
          end
          if(v == lineBreakElement)then
              lineOffset = lineOffset + lineSize + spacing
              lineSize = 1
              index = index + 1
              sortedElements[index] = {offset=lineOffset}
          else
              table.insert(sortedElements[index], v)
          end
      end
    elseif(wrap)then
      local lineSize = 1
      local lineOffset = 1

      local maxSize = direction == "row" and self:getWidth() or self:getHeight()
      local usedSize = 0
      local index = 1

      for _,v in pairs(elements) do
          if(sortedElements[index]==nil) then sortedElements[index]={offset=1} end

          if v == lineBreakFakeObject then
              lineOffset = lineOffset + lineSize + spacing
              usedSize = 0
              lineSize = 1
              index = index + 1
              sortedElements[index] = {offset=lineOffset}
          else
              local objSize = direction == "row" and v:getWidth() or v:getHeight()
              if(objSize+usedSize<=maxSize) then
                  table.insert(sortedElements[index], v)
                  usedSize = usedSize + objSize + spacing
              else
                  lineOffset = lineOffset + lineSize + spacing
                  lineSize = direction == "row" and v:getHeight() or v:getWidth()
                  index = index + 1
                  usedSize = objSize + spacing
                  sortedElements[index] = {offset=lineOffset, v}
              end

              local childHeight = direction == "row" and v:getHeight() or v:getWidth()
              if childHeight > lineSize then
                  lineSize = childHeight
              end
          end
      end
  end
    return sortedElements
end

local function calculateRow(self, children, spacing, justifyContent)
  local containerWidth, containerHeight = self:getSize()
  local totalFlexGrow = 0
  local totalFlexShrink = 0
  local totalFlexBasis = 0

  for _, child in ipairs(children) do
      totalFlexGrow = totalFlexGrow + child:getFlexGrow()
      totalFlexShrink = totalFlexShrink + child:getFlexShrink()
      totalFlexBasis = totalFlexBasis + child:getFlexBasis()
  end

  local remainingSpace = containerWidth - totalFlexBasis - (spacing * (#children - 1))

  local currentX = 1
  for _, child in ipairs(children) do
      if(child~=lineBreakElement)then
          local childWidth

          local flexGrow = child:getFlexGrow()
          local flexShrink = child:getFlexShrink()

          local baseWidth = child:getFlexBasis() ~= 0 and child:getFlexBasis() or child:getWidth()
          if totalFlexGrow > 0 then
              childWidth = baseWidth + flexGrow / totalFlexGrow * remainingSpace
          else
              childWidth = baseWidth
          end

          if remainingSpace < 0 and totalFlexShrink > 0 then
              childWidth = baseWidth + flexShrink / totalFlexShrink * remainingSpace
          end

          child:setPosition(currentX, children.offset or 1)
          child:setSize(childWidth, child:getHeight(), false, true)
          currentX = currentX + childWidth + spacing
      end
  end

  if justifyContent == "flex-end" then
      local totalWidth = currentX - spacing
      local offset = containerWidth - totalWidth + 1
      for _, child in ipairs(children) do
          local x, y = child:getPosition()
          child:setPosition(x + offset, y)
      end
  elseif justifyContent == "center" then
      local totalWidth = currentX - spacing
      local offset = (containerWidth - totalWidth) / 2 + 1
      for _, child in ipairs(children) do
          local x, y = child:getPosition()
          child:setPosition(x + offset, y)
      end
  elseif justifyContent == "space-between" then
      local totalWidth = currentX - spacing
      local offset = (containerWidth - totalWidth) / (#children - 1) + 1
      for i, child in ipairs(children) do
          if i > 1 then
              local x, y = child:getPosition()
              child:setPosition(x + offset * (i - 1), y)
          end
      end
  elseif justifyContent == "space-around" then
      local totalWidth = currentX - spacing
      local offset = (containerWidth - totalWidth) / #children
      for i, child in ipairs(children) do
          local x, y = child:getPosition()
          child:setPosition(x + offset * i - offset / 2, y)
      end
  elseif justifyContent == "space-evenly" then
      local numSpaces = #children + 1
      local totalChildWidth = 0
      for _, child in ipairs(children) do
          totalChildWidth = totalChildWidth + child:getWidth()
      end
      local totalSpace = containerWidth - totalChildWidth
      local offset = math.floor(totalSpace / numSpaces)
      local remaining = totalSpace - offset * numSpaces
      currentX = offset + (remaining > 0 and 1 or 0)
      remaining = remaining > 0 and remaining - 1 or 0
      for _, child in ipairs(children) do
          child:setPosition(currentX, 1)
          currentX = currentX + child:getWidth() + offset + (remaining > 0 and 1 or 0)
          remaining = remaining > 0 and remaining - 1 or 0
      end
  end
end

local function calculateColumn(self, children, spacing, justifyContent)
  local containerWidth, containerHeight = self:getSize()
  local totalFlexGrow = 0
  local totalFlexShrink = 0
  local totalFlexBasis = 0

  for _, child in ipairs(children) do
      totalFlexGrow = totalFlexGrow + child:getFlexGrow()
      totalFlexShrink = totalFlexShrink + child:getFlexShrink()
      totalFlexBasis = totalFlexBasis + child:getFlexBasis()
  end

  local remainingSpace = containerHeight - totalFlexBasis - (spacing * (#children - 1))

  local currentY = 1

  for _, child in ipairs(children) do
      if(child~=lineBreakElement)then
          local childHeight

          local flexGrow = child:getFlexGrow()
          local flexShrink = child:getFlexShrink()

          local baseHeight = child:getFlexBasis() ~= 0 and child:getFlexBasis() or child:getHeight()
          if totalFlexGrow > 0 then
              childHeight = baseHeight + flexGrow / totalFlexGrow * remainingSpace
          else
              childHeight = baseHeight
          end

          if remainingSpace < 0 and totalFlexShrink > 0 then
              childHeight = baseHeight + flexShrink / totalFlexShrink * remainingSpace
          end

          child:setPosition(children.offset, currentY)
          child:setSize(child:getWidth(), childHeight, false, true)
          currentY = currentY + childHeight + spacing
      end
  end

  if justifyContent == "flex-end" then
      local totalHeight = currentY - spacing
      local offset = containerHeight - totalHeight + 1
      for _, child in ipairs(children) do
          local x, y = child:getPosition()
          child:setPosition(x, y + offset)
      end
  elseif justifyContent == "center" then
      local totalHeight = currentY - spacing
      local offset = (containerHeight - totalHeight) / 2
      for _, child in ipairs(children) do
          local x, y = child:getPosition()
          child:setPosition(x, y + offset)
      end
  elseif justifyContent == "space-between" then
      local totalHeight = currentY - spacing
      local offset = (containerHeight - totalHeight) / (#children - 1) + 1
      for i, child in ipairs(children) do
          if i > 1 then
              local x, y = child:getPosition()
              child:setPosition(x, y + offset * (i - 1))
          end
      end
  elseif justifyContent == "space-around" then
      local totalHeight = currentY - spacing
      local offset = (containerHeight - totalHeight) / #children
      for i, child in ipairs(children) do
          local x, y = child:getPosition()
          child:setPosition(x, y + offset * i - offset / 2)
      end
  elseif justifyContent == "space-evenly" then
      local numSpaces = #children + 1
      local totalChildHeight = 0
      for _, child in ipairs(children) do
          totalChildHeight = totalChildHeight + child:getHeight()
      end
      local totalSpace = containerHeight - totalChildHeight
      local offset = math.floor(totalSpace / numSpaces)
      local remaining = totalSpace - offset * numSpaces
      currentY = offset + (remaining > 0 and 1 or 0)
      remaining = remaining > 0 and remaining - 1 or 0
      for _, child in ipairs(children) do
          local x, y = child:getPosition()
          child:setPosition(x, currentY)
          currentY = currentY + child:getHeight() + offset + (remaining > 0 and 1 or 0)
          remaining = remaining > 0 and remaining - 1 or 0
      end
  end
end

local function createLayout(self, direction, spacing, justifyContent, wrap)
  local elements = sortElements(self, direction, spacing, wrap)
    if direction == "row" then
        for _,v in pairs(elements)do
            calculateRow(self, v, spacing, justifyContent)
        end
    else
        for _,v in pairs(elements)do
            calculateColumn(self, v, spacing, justifyContent)
        end
    end
    self:setFlexCreateLayout(false)
end

function Flexbox:new(id, parent, basalt)
  local newInstance = Container:new(id, parent, basalt)
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:setType("Flexbox")
  newInstance:create("Flexbox")
  newInstance:setZ(10)
  newInstance:setSize(30, 12)
  newInstance:addPropertyObserver("width", function(self, value)
    self:setFlexCreateLayout(true)
  end)
  newInstance:addPropertyObserver("height", function(self, value)
    self:setFlexCreateLayout(true)
  end)
  return newInstance
end

function Flexbox:addChild(element, ...)
  Container.addChild(self, element, ...)
  
  if(element~=lineBreakElement)then
    element:setProperty("flexGrow", 1)
    element:setProperty("flexShrink", 1)
    element:setProperty("flexBasis", 1)
    element.setFlexGrow = function(self, value)
      self:setProperty("flexGrow", value)
      self:setFlexCreateLayout(true)
      return self
    end
    element.setFlexShrink = function(self, value)
      self:setProperty("flexShrink", value)
      self:setFlexCreateLayout(true)
      return self
    end
    element.setFlexBasis = function(self, value)
      self:setProperty("flexBasis", value)
      self:setFlexCreateLayout(true)
      return self
    end
    element.getFlexGrow = function(self)
      return self:getProperty("flexGrow")
    end
    element.getFlexShrink = function(self)
      return self:getProperty("flexShrink")
    end
    element.getFlexBasis = function(self)
      return self:getProperty("flexBasis")
    end
  end
  
  self:setFlexCreateLayout(true)
  return self
end

function Flexbox:removeChild(element, ...)
  Container.removeChild(self, element, ...)

  if(element~=lineBreakElement)then
    element.setFlexGrow = nil
    element.setFlexShrink = nil
    element.setFlexBasis = nil
    element.getFlexGrow = nil
    element.getFlexShrink = nil
    element.getFlexBasis = nil
    element:setProperty("flexGrow", nil)
    element:setProperty("flexShrink", nil)
    element:setProperty("flexBasis", nil)
  end

  self:setFlexCreateLayout(true)
  return self
end

function Flexbox:addLineBreak()
  self:addChild(lineBreakElement)
  return self
end

function Flexbox:setSize(...)
  Container.setSize(self, ...)
  self:setFlexCreateLayout(true)
end

function Flexbox:render()
  if(self:getFlexCreateLayout())then
    createLayout(self, self:getFlexDirection(), self:getFlexSpacing(), self:getFlexJustifyContent(), self:getFlexWrap())
  end
  Container.render(self)
end

return Flexbox