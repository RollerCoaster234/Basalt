local Container = require("basaltLoader").load("Container")
local log = require("log")

local MovableFrame = setmetatable({}, Container)

MovableFrame:initialize("MovableFrame")
MovableFrame:addProperty("dragMap", "table", {
    {x=1, y=1, w=0, h=1}
})

function MovableFrame:new(id, parent, basalt)
  local newInstance = Container:new(id, parent, basalt)
  setmetatable(newInstance, self)
  self.__index = self
  newInstance:setType("MovableFrame")
  newInstance:create("MovableFrame")
  newInstance:setZ(10)
  newInstance:setSize(30, 15)
  return newInstance
end

MovableFrame:extend("Load", function(self)
    self:listenEvent("mouse_click")
    self:listenEvent("mouse_up")
    self:listenEvent("mouse_drag")
end)

function MovableFrame:isInDragMap(x, y)
    local x, y = self:getRelativePosition(x, y)
    for _, v in pairs(self.dragMap)do
        local w, h = v.w-1, v.h-1
        if(v.w<=0)then w = self.width end
        if(v.h<=0)then h = self.height end
        if(x >= v.x and x <= v.x + w and y >= v.y and y <= v.y + h)then
            return true
        end
    end
    return false
end

function MovableFrame:addDragPoint(x, y, w, h)
    table.insert(self.dragMap, {x=x, y=y, w=w, h=h})
    return self
end

function MovableFrame:createDragMap(newMap)
    self.dragMap = newMap
    return self
end

function MovableFrame:mouse_click(button, x, y)
    if(Container.mouse_click(self, button, x, y))then
        if(button == 1)then
            if(self:isInDragMap(x, y))then
                self.isDragging = true
                self.dragX = x
                self.dragY = y
            end
            return true
        end
    end
end

function MovableFrame:mouse_up(button, x, y)
    self.isDragging = false
    return Container.mouse_up(self, button, x, y)
end

function MovableFrame:mouse_drag(button, x, y)
    Container.mouse_drag(self, button, x, y)
    if(self.isDragging)then
        local dx = x - self.dragX
        local dy = y - self.dragY
        self.dragX = x
        self.dragY = y
        self:setPosition(self.x + dx, self.y + dy)
        return true
    end
end

return MovableFrame